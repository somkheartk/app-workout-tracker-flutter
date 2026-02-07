class WorkoutSession {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final DateTime startTime;
  final DateTime? endTime;
  final List<CompletedExercise> completedExercises;
  final bool isCompleted;

  WorkoutSession({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.startTime,
    this.endTime,
    required this.completedExercises,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'planName': planName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'completedExercises': completedExercises.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      completedExercises: (json['completedExercises'] as List)
          .map((e) => CompletedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Duration get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return DateTime.now().difference(startTime);
  }
}

class CompletedExercise {
  final String name;
  final int setsCompleted;
  final int repsCompleted;
  final double? weight;

  CompletedExercise({
    required this.name,
    required this.setsCompleted,
    required this.repsCompleted,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'setsCompleted': setsCompleted,
      'repsCompleted': repsCompleted,
      'weight': weight,
    };
  }

  factory CompletedExercise.fromJson(Map<String, dynamic> json) {
    return CompletedExercise(
      name: json['name'] as String,
      setsCompleted: json['setsCompleted'] as int,
      repsCompleted: json['repsCompleted'] as int,
      weight: json['weight'] as double?,
    );
  }
}
