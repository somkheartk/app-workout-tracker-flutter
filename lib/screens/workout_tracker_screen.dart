import 'package:flutter/material.dart';
import '../models/workout_plan.dart';
import '../models/workout_session.dart';
import '../services/auth_service.dart';
import '../services/workout_session_service.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  final WorkoutPlan plan;

  const WorkoutTrackerScreen({super.key, required this.plan});

  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final _authService = AuthService();
  final _sessionService = WorkoutSessionService();
  WorkoutSession? _currentSession;
  final Map<int, Map<String, int>> _exerciseProgress = {};

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      _currentSession = WorkoutSession(
        id: sessionId,
        userId: user.id,
        planId: widget.plan.id,
        planName: widget.plan.name,
        startTime: DateTime.now(),
        completedExercises: [],
        isCompleted: false,
      );
      
      // Initialize progress tracking
      for (int i = 0; i < widget.plan.exercises.length; i++) {
        _exerciseProgress[i] = {'sets': 0, 'reps': 0};
      }
    }
  }

  void _updateProgress(int exerciseIndex, String type, int value) {
    setState(() {
      _exerciseProgress[exerciseIndex]![type] = value;
    });
  }

  Future<void> _completeWorkout() async {
    if (_currentSession == null) return;

    final completedExercises = <CompletedExercise>[];
    for (int i = 0; i < widget.plan.exercises.length; i++) {
      final exercise = widget.plan.exercises[i];
      final progress = _exerciseProgress[i]!;
      completedExercises.add(
        CompletedExercise(
          name: exercise.name,
          setsCompleted: progress['sets']!,
          repsCompleted: progress['reps']!,
          weight: exercise.weight,
        ),
      );
    }

    final completedSession = WorkoutSession(
      id: _currentSession!.id,
      userId: _currentSession!.userId,
      planId: _currentSession!.planId,
      planName: _currentSession!.planName,
      startTime: _currentSession!.startTime,
      endTime: DateTime.now(),
      completedExercises: completedExercises,
      isCompleted: true,
    );

    await _sessionService.saveSession(completedSession);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout completed!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.name),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.plan.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.plan.exercises[index];
          final progress = _exerciseProgress[index] ?? {'sets': 0, 'reps': 0};

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Target: ${exercise.sets} sets × ${exercise.reps} reps'
                    '${exercise.weight != null ? ' @ ${exercise.weight}kg' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sets Completed'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: progress['sets']! > 0
                                      ? () => _updateProgress(
                                          index, 'sets', progress['sets']! - 1)
                                      : null,
                                ),
                                Text(
                                  '${progress['sets']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _updateProgress(
                                      index, 'sets', progress['sets']! + 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Reps per Set'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: progress['reps']! > 0
                                      ? () => _updateProgress(
                                          index, 'reps', progress['reps']! - 1)
                                      : null,
                                ),
                                Text(
                                  '${progress['reps']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _updateProgress(
                                      index, 'reps', progress['reps']! + 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (progress['sets']! >= exercise.sets)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Complete!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _completeWorkout,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Complete Workout',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
