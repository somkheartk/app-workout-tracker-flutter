import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_group.dart';

class WorkoutGroupService {
  static const String _groupsKey = 'workout_groups';

  Future<List<WorkoutGroup>> getGroups(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    
    if (groupsJson != null) {
      final List<dynamic> groupsList = jsonDecode(groupsJson);
      return groupsList
          .map((json) => WorkoutGroup.fromJson(json))
          .where((group) => group.memberIds.contains(userId))
          .toList();
    }
    return [];
  }

  Future<void> createGroup(WorkoutGroup group) async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    
    List<dynamic> groupsList = [];
    if (groupsJson != null) {
      groupsList = jsonDecode(groupsJson);
    }
    
    groupsList.add(group.toJson());
    await prefs.setString(_groupsKey, jsonEncode(groupsList));
  }

  Future<void> joinGroup(String groupId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    
    if (groupsJson != null) {
      List<dynamic> groupsList = jsonDecode(groupsJson);
      final groupIndex = groupsList.indexWhere((g) => g['id'] == groupId);
      
      if (groupIndex >= 0) {
        final group = WorkoutGroup.fromJson(groupsList[groupIndex]);
        if (!group.memberIds.contains(userId)) {
          final updatedGroup = WorkoutGroup(
            id: group.id,
            name: group.name,
            description: group.description,
            memberIds: [...group.memberIds, userId],
            adminId: group.adminId,
            createdAt: group.createdAt,
          );
          groupsList[groupIndex] = updatedGroup.toJson();
          await prefs.setString(_groupsKey, jsonEncode(groupsList));
        }
      }
    }
  }
}
