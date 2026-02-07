class WorkoutGroup {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final String adminId;
  final DateTime createdAt;

  WorkoutGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.adminId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'adminId': adminId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkoutGroup.fromJson(Map<String, dynamic> json) {
    return WorkoutGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      memberIds: List<String>.from(json['memberIds'] as List),
      adminId: json['adminId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
