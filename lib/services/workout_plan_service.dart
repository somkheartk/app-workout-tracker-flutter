import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_plan.dart';

class WorkoutPlanService {
  static const String _plansKey = 'workout_plans';

  Future<List<WorkoutPlan>> getPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final plansJson = prefs.getString(_plansKey);
    
    if (plansJson != null) {
      final List<dynamic> plansList = jsonDecode(plansJson);
      return plansList.map((json) => WorkoutPlan.fromJson(json)).toList();
    }
    
    // Return default plans if none exist
    return _getDefaultPlans();
  }

  Future<void> savePlan(WorkoutPlan plan) async {
    final plans = await getPlans();
    plans.add(plan);
    await _savePlans(plans);
  }

  Future<void> _savePlans(List<WorkoutPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    final plansJson = jsonEncode(plans.map((p) => p.toJson()).toList());
    await prefs.setString(_plansKey, plansJson);
  }

  List<WorkoutPlan> _getDefaultPlans() {
    return [
      WorkoutPlan(
        id: '1',
        name: 'Beginner Full Body',
        description: 'A simple full body workout for beginners',
        createdAt: DateTime.now(),
        exercises: [
          WorkoutExercise(name: 'Push-ups', sets: 3, reps: 10),
          WorkoutExercise(name: 'Squats', sets: 3, reps: 15),
          WorkoutExercise(name: 'Plank', sets: 3, reps: 30),
        ],
      ),
      WorkoutPlan(
        id: '2',
        name: 'Upper Body Strength',
        description: 'Focus on upper body muscles',
        createdAt: DateTime.now(),
        exercises: [
          WorkoutExercise(name: 'Bench Press', sets: 4, reps: 8, weight: 60),
          WorkoutExercise(name: 'Pull-ups', sets: 3, reps: 8),
          WorkoutExercise(name: 'Shoulder Press', sets: 3, reps: 10, weight: 30),
          WorkoutExercise(name: 'Bicep Curls', sets: 3, reps: 12, weight: 15),
        ],
      ),
      WorkoutPlan(
        id: '3',
        name: 'Lower Body Power',
        description: 'Build strong legs and core',
        createdAt: DateTime.now(),
        exercises: [
          WorkoutExercise(name: 'Squats', sets: 4, reps: 10, weight: 80),
          WorkoutExercise(name: 'Deadlifts', sets: 4, reps: 8, weight: 100),
          WorkoutExercise(name: 'Lunges', sets: 3, reps: 12),
          WorkoutExercise(name: 'Calf Raises', sets: 3, reps: 15),
        ],
      ),
    ];
  }
}
