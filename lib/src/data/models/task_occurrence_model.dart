import 'package:dart_mappable/dart_mappable.dart';

part 'task_occurrence_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceMediaModel with TaskOccurrenceMediaModelMappable {
  TaskOccurrenceMediaModel({required this.id, this.url});

  final int id;
  final String? url;

  static const fromJson = TaskOccurrenceMediaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceChecklistAnswerModel
    with TaskOccurrenceChecklistAnswerModelMappable {
  TaskOccurrenceChecklistAnswerModel({
    this.id,
    this.responseType,
    this.ratingValue,
    this.booleanValue,
    this.textValue,
    this.hasProof,
  });

  final int? id;

  @MappableField(key: 'response_type')
  final String? responseType;

  @MappableField(key: 'rating_value')
  final int? ratingValue;

  @MappableField(key: 'boolean_value')
  final bool? booleanValue;

  @MappableField(key: 'text_value')
  final String? textValue;

  @MappableField(key: 'has_photo')
  final bool? hasProof;

  static const fromJson = TaskOccurrenceChecklistAnswerModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceChecklistItemModel
    with TaskOccurrenceChecklistItemModelMappable {
  TaskOccurrenceChecklistItemModel({
    required this.id,
    this.label,
    this.responseType,
    this.response,
  });

  final int id;
  final String? label;

  @MappableField(key: 'response_type')
  final String? responseType;

  final TaskOccurrenceChecklistAnswerModel? response;

  static const fromJson = TaskOccurrenceChecklistItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceModel with TaskOccurrenceModelMappable {
  TaskOccurrenceModel({
    required this.id,
    this.taskScheduleId,
    this.scheduleTitle,
    this.taskType,
    this.facilityId,
    this.occurrenceDate,
    this.slotStart,
    this.slotEnd,
    this.timeRange,
    this.assignedTo,
    this.assignedToName,
    this.status,
    this.submittedAt,
    this.submittedBy,
    this.submittedByName,
    this.lateByMinutes,
    this.checklistResponseId,
    this.checklistItems,
    this.missedAlertSent,
    this.supervisorNote,
  });

  final int id;

  @MappableField(key: 'task_schedule_id')
  final int? taskScheduleId;

  @MappableField(key: 'schedule_title')
  final String? scheduleTitle;

  @MappableField(key: 'task_type')
  final String? taskType;

  @MappableField(key: 'facility_id')
  final int? facilityId;

  @MappableField(key: 'occurrence_date')
  final String? occurrenceDate;

  @MappableField(key: 'slot_start')
  final String? slotStart;

  @MappableField(key: 'slot_end')
  final String? slotEnd;

  @MappableField(key: 'time_range')
  final String? timeRange;

  @MappableField(key: 'assigned_to')
  final int? assignedTo;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  final String? status;

  @MappableField(key: 'submitted_at')
  final String? submittedAt;

  @MappableField(key: 'submitted_by')
  final int? submittedBy;

  @MappableField(key: 'submitted_by_name')
  final String? submittedByName;

  @MappableField(key: 'late_by_minutes')
  final int? lateByMinutes;

  @MappableField(key: 'checklist_response_id')
  final int? checklistResponseId;

  @MappableField(key: 'checklist_items')
  final List<TaskOccurrenceChecklistItemModel>? checklistItems;

  @MappableField(key: 'missed_alert_sent')
  final bool? missedAlertSent;

  @MappableField(key: 'supervisor_note')
  final String? supervisorNote;

  static const fromJson = TaskOccurrenceModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceStatsModel with TaskOccurrenceStatsModelMappable {
  TaskOccurrenceStatsModel({
    this.totalSlots,
    this.onTime,
    this.late,
    this.missed,
    this.pending,
    this.complianceScore,
  });

  @MappableField(key: 'total_slots')
  final int? totalSlots;

  @MappableField(key: 'on_time')
  final int? onTime;

  final int? late;
  final int? missed;
  final int? pending;

  @MappableField(key: 'compliance_score')
  final int? complianceScore;

  static const fromJson = TaskOccurrenceStatsModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceListResponseModel
    with TaskOccurrenceListResponseModelMappable {
  TaskOccurrenceListResponseModel({this.data, this.stats});

  final List<TaskOccurrenceModel>? data;
  final TaskOccurrenceStatsModel? stats;

  static const fromJson = TaskOccurrenceListResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceDetailResponseModel
    with TaskOccurrenceDetailResponseModelMappable {
  TaskOccurrenceDetailResponseModel({this.data});

  final TaskOccurrenceModel? data;

  static const fromJson = TaskOccurrenceDetailResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TaskOccurrenceChecklistItemSaveResponseModel
    with TaskOccurrenceChecklistItemSaveResponseModelMappable {
  TaskOccurrenceChecklistItemSaveResponseModel({this.data, this.media});

  final TaskOccurrenceChecklistAnswerModel? data;
  final TaskOccurrenceMediaModel? media;

  static const fromJson =
      TaskOccurrenceChecklistItemSaveResponseModelMapper.fromJson;
}
