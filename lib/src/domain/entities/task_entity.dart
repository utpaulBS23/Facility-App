import '../../core/utils/localized_text.dart';

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

  /// The proof photo taken when completing, as opposed to the one the
  /// reporter attached when creating the issue.
  bool get isCompletionProof => purpose == 'completion';
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
    this.titleBn = '',
    this.descriptionBn = '',
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
  final String titleBn;
  final String description;
  final String descriptionBn;
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

  /// A photo from whoever completes the task. The reporter's creation photo
  /// does not count: completing still asks for its own proof.
  bool get hasCompletionProof => media.any((m) => m.isCompletionProof);
  final DateTime? createdDate;
  final DateTime? resolvedDate;

  String localizedTitle(String languageCode) =>
      localizedText(languageCode, title, titleBn);

  String localizedDescription(String languageCode) =>
      localizedText(languageCode, description, descriptionBn);

  TaskEntity copyWith({
    int? id,
    String? title,
    String? titleBn,
    String? description,
    String? descriptionBn,
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
      titleBn: titleBn ?? this.titleBn,
      description: description ?? this.description,
      descriptionBn: descriptionBn ?? this.descriptionBn,
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
