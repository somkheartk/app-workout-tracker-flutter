import 'package:flutter/material.dart';
import '../models/workout_plan.dart';
import '../services/workout_plan_service.dart';
import 'workout_tracker_screen.dart';

class WorkoutPlansScreen extends StatefulWidget {
  const WorkoutPlansScreen({super.key});

  @override
  State<WorkoutPlansScreen> createState() => _WorkoutPlansScreenState();
}

class _WorkoutPlansScreenState extends State<WorkoutPlansScreen> {
  final _planService = WorkoutPlanService();
  List<WorkoutPlan> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _isLoading = true);
    final plans = await _planService.getPlans();
    setState(() {
      _plans = plans;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _plans.isEmpty
          ? const Center(
              child: Text(
                'No workout plans available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WorkoutTrackerScreen(plan: plan),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fitness_center, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  plan.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${plan.exercises.length} exercises',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: plan.exercises.map((exercise) {
                              return Chip(
                                label: Text(
                                  exercise.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
