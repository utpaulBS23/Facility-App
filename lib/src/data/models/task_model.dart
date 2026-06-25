import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.mapper.dart';

String _formatDueTime(String? raw) {
  if (raw == null) return '';
  try {
    final dt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(raw);
    return DateFormat('hh:mm a').format(dt);
  } catch (_) {
    return raw;
  }
}

TaskPriority _mapPriority(String raw) => switch (raw.toLowerCase()) {
  'high' => TaskPriority.high,
  'medium' => TaskPriority.medium,
  _ => TaskPriority.low,
};

TaskStatus _mapStatus(String raw) => switch (raw.toLowerCase()) {
  'completed' => TaskStatus.completed,
  'pending' => TaskStatus.pending,
  _ => TaskStatus.today,
};

// ─── List response ─────────────────────────────────────────────────────────

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskListResponseModel with TaskListResponseModelMappable {
  TaskListResponseModel({required this.data});

  final List<TaskModel> data;

  static const fromJson = TaskListResponseModelMapper.fromJson;

  List<TaskEntity> toEntities(TaskStatus status) =>
      data.map((e) => e.toEntity(status)).toList();
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskModel with TaskModelMappable {
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.facilityName,
    this.dueAt,
    required this.status,
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

  final String status;
  final String priority;
  final TaskIssueModel? issue;
  final List<TaskMediaModel>? media;

  static const fromJson = TaskModelMapper.fromJson;

  TaskEntity toEntity(TaskStatus bucketStatus) => TaskEntity(
        id: id,
        title: title,
        description: description ?? '',
        location: facilityName ?? '',
        dueTime: _formatDueTime(dueAt),
        priority: _mapPriority(priority),
        status: bucketStatus,
        proofRequiredOnComplete: issue?.proofRequiredOnComplete ?? false,
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
    required this.status,
    required this.priority,
    this.proofRequiredOnComplete = false,
    this.media,
  });

  final int id;
  final String title;
  final String? description;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'due_at')
  final String? dueAt;

  final String status;
  final String priority;

  @MappableField(key: 'proof_required_on_complete')
  final bool proofRequiredOnComplete;

  final List<TaskMediaModel>? media;

  static const fromJson = TaskDetailModelMapper.fromJson;

  TaskEntity toEntity() => TaskEntity(
        id: id,
        title: title,
        description: description ?? '',
        location: facilityName ?? '',
        dueTime: _formatDueTime(dueAt),
        priority: _mapPriority(priority),
        status: _mapStatus(status),
        proofRequiredOnComplete: proofRequiredOnComplete,
        media: media
                ?.map(
                  (m) => TaskMediaEntity(id: m.id, url: m.url, alt: m.alt),
                )
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
}
