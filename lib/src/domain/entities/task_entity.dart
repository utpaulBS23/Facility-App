enum TaskPriority { high, medium, low }

enum TaskStatus { today, pending, completed }

class TaskMediaEntity {
  const TaskMediaEntity({required this.id, required this.url, this.alt});

  final int id;
  final String url;
  final String? alt;
}

class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dueTime,
    required this.priority,
    required this.status,
    this.proofRequiredOnComplete = false,
    this.media = const [],
  });

  final int id;
  final String title;
  final String description;
  final String location;
  final String dueTime;
  final TaskPriority priority;
  final TaskStatus status;
  final bool proofRequiredOnComplete;
  final List<TaskMediaEntity> media;
}
