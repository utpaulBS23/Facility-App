enum TaskPriority { high, medium, low }

// WHY: mirrors task_issues.status (the Issue List/Show API's own vocabulary),
// not tasks.status — see Issue List/Show/Start/Complete API testing notes.
enum TaskStatus { open, inProgress, resolved, closed }

class TaskMediaEntity {
  const TaskMediaEntity({
    required this.id,
    required this.url,
    this.alt,
    this.purpose = 'creation',
  });

  final int id;
  final String url;
  final String? alt;
  final String purpose;
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
    this.facilityId,
    this.facilityAddress = '',
    this.assignedToId,
    this.assignedToName = '',
    this.problemCategory = '',
    this.proofRequiredOnComplete = false,
    this.media = const [],
    this.createdDate,
    this.resolvedDate,
  });

  final int id;
  final String title;
  final String description;
  final String location;
  final String facilityAddress;
  final String dueTime;
  final TaskPriority priority;
  final TaskStatus status;
  final int? facilityId;
  final int? assignedToId;
  final String assignedToName;
  final String problemCategory;
  final bool proofRequiredOnComplete;
  final List<TaskMediaEntity> media;
  final DateTime? createdDate;
  final DateTime? resolvedDate;

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    String? facilityAddress,
    String? dueTime,
    TaskPriority? priority,
    TaskStatus? status,
    int? facilityId,
    int? assignedToId,
    String? assignedToName,
    String? problemCategory,
    bool? proofRequiredOnComplete,
    List<TaskMediaEntity>? media,
    DateTime? createdDate,
    DateTime? resolvedDate,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      facilityAddress: facilityAddress ?? this.facilityAddress,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      facilityId: facilityId ?? this.facilityId,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      problemCategory: problemCategory ?? this.problemCategory,
      proofRequiredOnComplete:
          proofRequiredOnComplete ?? this.proofRequiredOnComplete,
      media: media ?? this.media,
      createdDate: createdDate ?? this.createdDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
    );
  }
}
