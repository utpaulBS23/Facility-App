/// `task_occurrences.status` — never chosen by the caller. [pending] is the
/// default from generation; [onTime]/[late] are set by submit (§7); [missed]
/// is set only by the next midnight's cron, never by this app.
enum TaskOccurrenceStatus { pending, onTime, late, missed }

TaskOccurrenceStatus taskOccurrenceStatusFromKey(String key) => switch (key) {
  'on_time' => TaskOccurrenceStatus.onTime,
  'late' => TaskOccurrenceStatus.late,
  'missed' => TaskOccurrenceStatus.missed,
  _ => TaskOccurrenceStatus.pending,
};

/// Which field on [ChecklistItemAnswerEntity] a [TaskOccurrenceChecklistItemEntity]
/// expects an answer in.
enum TaskOccurrenceChecklistResponseType { rating, boolean, text }

TaskOccurrenceChecklistResponseType taskOccurrenceChecklistResponseTypeFromKey(
  String? key,
) => switch (key) {
  'boolean' => TaskOccurrenceChecklistResponseType.boolean,
  'text' => TaskOccurrenceChecklistResponseType.text,
  _ => TaskOccurrenceChecklistResponseType.rating,
};

/// One answer a checklist item may hold — `null` per-field until answered.
class ChecklistItemAnswerEntity {
  const ChecklistItemAnswerEntity({
    this.id,
    this.ratingValue,
    this.booleanValue,
    this.textValue,
    this.hasProof = false,
    this.mediaUrl,
  });

  final int? id;
  final int? ratingValue;
  final bool? booleanValue;
  final String? textValue;
  final bool hasProof;
  final String? mediaUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemAnswerEntity &&
          id == other.id &&
          ratingValue == other.ratingValue &&
          booleanValue == other.booleanValue &&
          textValue == other.textValue &&
          hasProof == other.hasProof &&
          mediaUrl == other.mediaUrl;

  @override
  int get hashCode =>
      Object.hash(id, ratingValue, booleanValue, textValue, hasProof, mediaUrl);
}

/// One checklist item on a [TaskOccurrenceEntity] — `response` is `null`
/// until answered via the checklist-item endpoint.
class TaskOccurrenceChecklistItemEntity {
  const TaskOccurrenceChecklistItemEntity({
    required this.id,
    required this.label,
    required this.responseType,
    this.response,
  });

  final int id;
  final String label;
  final TaskOccurrenceChecklistResponseType responseType;
  final ChecklistItemAnswerEntity? response;

  bool get isAnswered => response != null;

  TaskOccurrenceChecklistItemEntity copyWith({
    ChecklistItemAnswerEntity? response,
  }) => TaskOccurrenceChecklistItemEntity(
    id: id,
    label: label,
    responseType: responseType,
    response: response ?? this.response,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskOccurrenceChecklistItemEntity &&
          id == other.id &&
          label == other.label &&
          responseType == other.responseType &&
          response == other.response;

  @override
  int get hashCode => Object.hash(id, label, responseType, response);
}

/// One generated slot for a facility on a day. Occurrences are never
/// created/deleted via the API — always whatever the nightly cron generated.
class TaskOccurrenceEntity {
  const TaskOccurrenceEntity({
    required this.id,
    required this.taskScheduleId,
    required this.scheduleTitle,
    required this.taskType,
    required this.facilityId,
    required this.occurrenceDate,
    required this.slotStart,
    required this.slotEnd,
    required this.timeRange,
    required this.status,
    this.assignedTo,
    this.assignedToName,
    this.submittedAt,
    this.submittedBy,
    this.submittedByName,
    this.lateByMinutes,
    this.checklistResponseId,
    this.checklistItems,
    this.missedAlertSent = false,
    this.supervisorNote,
  });

  final int id;
  final int taskScheduleId;
  final String scheduleTitle;
  final String taskType;
  final int facilityId;
  final String occurrenceDate;
  final String slotStart;
  final String slotEnd;
  final String timeRange;
  final TaskOccurrenceStatus status;
  final int? assignedTo;
  final String? assignedToName;
  final String? submittedAt;
  final int? submittedBy;
  final String? submittedByName;
  final int? lateByMinutes;
  final int? checklistResponseId;

  /// `null` when the schedule has no checklist template attached — distinct
  /// from an empty list.
  final List<TaskOccurrenceChecklistItemEntity>? checklistItems;
  final bool missedAlertSent;
  final String? supervisorNote;

  /// `null` checklist means nothing to gate submit on.
  bool get hasChecklist => checklistItems != null;

  bool get isChecklistComplete =>
      checklistItems?.every((item) => item.isAnswered) ?? true;

  TaskOccurrenceEntity copyWith({
    int? assignedTo,
    String? assignedToName,
    TaskOccurrenceStatus? status,
    String? submittedAt,
    int? submittedBy,
    String? submittedByName,
    int? lateByMinutes,
    List<TaskOccurrenceChecklistItemEntity>? checklistItems,
  }) => TaskOccurrenceEntity(
    id: id,
    taskScheduleId: taskScheduleId,
    scheduleTitle: scheduleTitle,
    taskType: taskType,
    facilityId: facilityId,
    occurrenceDate: occurrenceDate,
    slotStart: slotStart,
    slotEnd: slotEnd,
    timeRange: timeRange,
    status: status ?? this.status,
    assignedTo: assignedTo ?? this.assignedTo,
    assignedToName: assignedToName ?? this.assignedToName,
    submittedAt: submittedAt ?? this.submittedAt,
    submittedBy: submittedBy ?? this.submittedBy,
    submittedByName: submittedByName ?? this.submittedByName,
    lateByMinutes: lateByMinutes ?? this.lateByMinutes,
    checklistResponseId: checklistResponseId,
    checklistItems: checklistItems ?? this.checklistItems,
    missedAlertSent: missedAlertSent,
    supervisorNote: supervisorNote,
  );
}

/// Live-computed board stats — recalculated on every list request, never
/// read from the historical compliance table.
class TaskOccurrenceStatsEntity {
  const TaskOccurrenceStatsEntity({
    required this.totalSlots,
    required this.onTime,
    required this.late,
    required this.missed,
    required this.pending,
    required this.complianceScore,
  });

  final int totalSlots;
  final int onTime;
  final int late;
  final int missed;
  final int pending;
  final int complianceScore;
}

/// §4's response — the "Facility Slot Board" for one facility/day.
class TaskOccurrenceListEntity {
  const TaskOccurrenceListEntity({
    required this.occurrences,
    required this.stats,
  });

  final List<TaskOccurrenceEntity> occurrences;
  final TaskOccurrenceStatsEntity stats;
}
