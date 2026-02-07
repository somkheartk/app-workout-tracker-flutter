import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout_session.dart';
import '../services/auth_service.dart';
import '../services/workout_session_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _authService = AuthService();
  final _sessionService = WorkoutSessionService();
  List<WorkoutSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    final user = await _authService.getCurrentUser();
    if (user != null) {
      final sessions = await _sessionService.getSessions(user.id);
      setState(() {
        _sessions = sessions.where((s) => s.isCompleted).toList();
        _isLoading = false;
      });
    }
  }

  Map<String, int> _getWorkoutCounts() {
    final counts = <String, int>{};
    for (var session in _sessions) {
      counts[session.planName] = (counts[session.planName] ?? 0) + 1;
    }
    return counts;
  }

  List<FlSpot> _getWeeklyWorkoutData() {
    final now = DateTime.now();
    final weekData = <int, int>{};
    
    for (int i = 0; i < 7; i++) {
      weekData[i] = 0;
    }
    
    for (var session in _sessions) {
      final daysDiff = now.difference(session.startTime).inDays;
      if (daysDiff < 7) {
        final index = 6 - daysDiff;
        weekData[index] = (weekData[index] ?? 0) + 1;
      }
    }
    
    return weekData.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final workoutCounts = _getWorkoutCounts();
    final weeklyData = _getWeeklyWorkoutData();
    final totalWorkouts = _sessions.length;
    final totalMinutes = _sessions.fold<int>(
      0,
      (sum, session) => sum + session.duration.inMinutes,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.fitness_center, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          '$totalWorkouts',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Workouts'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.timer, size: 32, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          '$totalMinutes',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Minutes'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Weekly Chart
          const Text(
            'Last 7 Days',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return Text(days[value.toInt()]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weeklyData,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Workout History
          const Text(
            'Workout Breakdown',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (workoutCounts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No workout history yet'),
              ),
            )
          else
            ...workoutCounts.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: Text(entry.key),
                  trailing: Text(
                    '${entry.value} times',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          
          // Recent Sessions
          const Text(
            'Recent Sessions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_sessions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No completed sessions yet'),
              ),
            )
          else
            ..._sessions.take(5).map((session) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(session.planName),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(session.startTime),
                  ),
                  trailing: Text(
                    '${session.duration.inMinutes} min',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
