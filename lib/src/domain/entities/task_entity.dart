enum TaskPriority { high, medium, low }

// WHY: mirrors task_issues.status (the Issue List/Show API's own vocabulary),
// not tasks.status — see Issue List/Show/Start/Complete API testing notes.
enum TaskStatus { open, inProgress, resolved, closed }

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

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    String? dueTime,
    TaskPriority? priority,
    TaskStatus? status,
    bool? proofRequiredOnComplete,
    List<TaskMediaEntity>? media,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      proofRequiredOnComplete:
          proofRequiredOnComplete ?? this.proofRequiredOnComplete,
      media: media ?? this.media,
    );
  }
}
