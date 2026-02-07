import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_session.dart';

class WorkoutSessionService {
  static const String _sessionsKey = 'workout_sessions';

  Future<List<WorkoutSession>> getSessions(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString(_sessionsKey);
    
    if (sessionsJson != null) {
      final List<dynamic> sessionsList = jsonDecode(sessionsJson);
      return sessionsList
          .map((json) => WorkoutSession.fromJson(json))
          .where((session) => session.userId == userId)
          .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
    }
    return [];
  }

  Future<void> saveSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString(_sessionsKey);
    
    List<dynamic> sessionsList = [];
    if (sessionsJson != null) {
      sessionsList = jsonDecode(sessionsJson);
    }
    
    // Update existing session or add new one
    final existingIndex = sessionsList.indexWhere((s) => s['id'] == session.id);
    if (existingIndex >= 0) {
      sessionsList[existingIndex] = session.toJson();
    } else {
      sessionsList.add(session.toJson());
    }
    
    await prefs.setString(_sessionsKey, jsonEncode(sessionsList));
  }

  Future<WorkoutSession?> getActiveSession(String userId) async {
    final sessions = await getSessions(userId);
    try {
      return sessions.firstWhere((s) => !s.isCompleted);
    } catch (e) {
      return null;
    }
  }
}
