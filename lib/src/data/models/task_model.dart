import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task_entity.dart';
import '../../presentation/core/utils/date_formatter.dart';

part 'task_model.mapper.dart';

String _formatDueTime(String? raw) {
  if (raw == null) return '';
  try {
    final dt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(raw);
    return DateFormatter.timestamp(dt);
  } catch (_) {
    return raw;
  }
}

TaskPriority _mapPriority(String raw) => switch (raw.toLowerCase()) {
  'high' => TaskPriority.high,
  'medium' => TaskPriority.medium,
  _ => TaskPriority.low,
};

// WHY: task_issues.status vocabulary (open/in_progress/resolved/closed) —
// the Issue List/Show API's `issue_status` field, not `tasks.status`.
TaskStatus _mapIssueStatus(String raw) => switch (raw.toLowerCase()) {
  'in_progress' => TaskStatus.inProgress,
  'resolved' => TaskStatus.resolved,
  'closed' => TaskStatus.closed,
  _ => TaskStatus.open,
};

// ─── List response ─────────────────────────────────────────────────────────

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskListResponseModel with TaskListResponseModelMappable {
  TaskListResponseModel({required this.data});

  final List<TaskModel> data;

  static const fromJson = TaskListResponseModelMapper.fromJson;

  List<TaskEntity> toEntities() => data.map((e) => e.toEntity()).toList();
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskModel with TaskModelMappable {
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.facilityName,
    this.dueAt,
    required this.issueStatus,
    required this.priority,
    this.issue,
    this.media,
  });

  final int id;
  final String title;
  final String? description;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'due_at')
  final String? dueAt;

  @MappableField(key: 'issue_status')
  final String issueStatus;

  final String priority;
  final TaskIssueModel? issue;
  final List<TaskMediaModel>? media;

  static const fromJson = TaskModelMapper.fromJson;

  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description ?? '',
    location: facilityName ?? '',
    dueTime: _formatDueTime(dueAt),
    priority: _mapPriority(priority),
    status: _mapIssueStatus(issueStatus),
    proofRequiredOnComplete: issue?.proofRequiredOnComplete ?? false,
    media:
        media
            ?.map((m) => TaskMediaEntity(id: m.id, url: m.url, alt: m.alt))
            .toList() ??
        [],
  );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskIssueModel with TaskIssueModelMappable {
  TaskIssueModel({
    this.problemCategoryName,
    this.proofRequiredOnComplete = false,
  });

  @MappableField(key: 'problem_category_name')
  final String? problemCategoryName;

  @MappableField(key: 'proof_required_on_complete')
  final bool proofRequiredOnComplete;

  static const fromJson = TaskIssueModelMapper.fromJson;
}

// ─── Detail response ────────────────────────────────────────────────────────

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskDetailResponseModel with TaskDetailResponseModelMappable {
  TaskDetailResponseModel({required this.data});

  final TaskDetailModel data;

  static const fromJson = TaskDetailResponseModelMapper.fromJson;

  TaskEntity toEntity() => data.toEntity();
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskDetailModel with TaskDetailModelMappable {
  TaskDetailModel({
    required this.id,
    required this.title,
    this.description,
    this.facilityName,
    this.dueAt,
    required this.issueStatus,
    required this.priority,
    this.proofRequiredOnComplete = false,
    this.issue,
    this.media,
  });

  final int id;
  final String title;
  final String? description;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'due_at')
  final String? dueAt;

  @MappableField(key: 'issue_status')
  final String issueStatus;

  final String priority;

  @MappableField(key: 'proof_required_on_complete')
  final bool proofRequiredOnComplete;

  final TaskIssueModel? issue;
  final List<TaskMediaModel>? media;

  static const fromJson = TaskDetailModelMapper.fromJson;

  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description ?? '',
    location: facilityName ?? '',
    dueTime: _formatDueTime(dueAt),
    priority: _mapPriority(priority),
    status: _mapIssueStatus(issueStatus),
    proofRequiredOnComplete:
        proofRequiredOnComplete || (issue?.proofRequiredOnComplete ?? false),
    media:
        media
            ?.map((m) => TaskMediaEntity(id: m.id, url: m.url, alt: m.alt))
            .toList() ??
        [],
  );
}

// ─── Shared ─────────────────────────────────────────────────────────────────

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskMediaModel with TaskMediaModelMappable {
  TaskMediaModel({required this.id, required this.url, this.alt});

  final int id;
  final String url;
  final String? alt;

  static const fromJson = TaskMediaModelMapper.fromJson;

  TaskMediaEntity toEntity() => TaskMediaEntity(id: id, url: url, alt: alt);
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskMediaResponseModel with TaskMediaResponseModelMappable {
  TaskMediaResponseModel({required this.data});

  final TaskMediaModel data;

  static const fromJson = TaskMediaResponseModelMapper.fromJson;

  TaskMediaEntity toEntity() => data.toEntity();
}
