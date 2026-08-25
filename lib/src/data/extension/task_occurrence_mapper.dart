import '../../domain/entities/task_occurrence_entity.dart';
import '../models/task_occurrence_model.dart';

extension TaskOccurrenceChecklistAnswerModelToEntity
    on TaskOccurrenceChecklistAnswerModel {
  ChecklistItemAnswerEntity toEntity({String? mediaUrl}) =>
      ChecklistItemAnswerEntity(
        id: id,
        ratingValue: ratingValue,
        booleanValue: booleanValue,
        textValue: textValue,
        hasProof: hasProof ?? false,
        mediaUrl: mediaUrl,
      );
}

extension TaskOccurrenceChecklistItemModelToEntity
    on TaskOccurrenceChecklistItemModel {
  TaskOccurrenceChecklistItemEntity toEntity() =>
      TaskOccurrenceChecklistItemEntity(
        id: id,
        label: label ?? '',
        responseType: taskOccurrenceChecklistResponseTypeFromKey(responseType),
        response: response?.toEntity(),
      );
}

extension TaskOccurrenceModelToEntity on TaskOccurrenceModel {
  TaskOccurrenceEntity toEntity() => TaskOccurrenceEntity(
    id: id,
    taskScheduleId: taskScheduleId ?? 0,
    scheduleTitle: scheduleTitle ?? '',
    taskType: taskType ?? '',
    facilityId: facilityId ?? 0,
    occurrenceDate: occurrenceDate ?? '',
    slotStart: slotStart ?? '',
    slotEnd: slotEnd ?? '',
    timeRange: timeRange ?? '',
    status: taskOccurrenceStatusFromKey(status ?? 'pending'),
    assignedTo: assignedTo,
    assignedToName: assignedToName,
    submittedAt: submittedAt,
    submittedBy: submittedBy,
    submittedByName: submittedByName,
    lateByMinutes: lateByMinutes,
    checklistResponseId: checklistResponseId,
    checklistItems: checklistItems?.map((item) => item.toEntity()).toList(),
    missedAlertSent: missedAlertSent ?? false,
    supervisorNote: supervisorNote,
  );
}

extension TaskOccurrenceStatsModelToEntity on TaskOccurrenceStatsModel {
  TaskOccurrenceStatsEntity toEntity() => TaskOccurrenceStatsEntity(
    totalSlots: totalSlots ?? 0,
    onTime: onTime ?? 0,
    late: late ?? 0,
    missed: missed ?? 0,
    pending: pending ?? 0,
    complianceScore: complianceScore ?? 0,
  );
}

extension TaskOccurrenceDetailResponseModelToEntity
    on TaskOccurrenceDetailResponseModel {
  TaskOccurrenceEntity? toEntity() => data?.toEntity();
}

extension TaskOccurrenceChecklistItemSaveResponseModelToEntity
    on TaskOccurrenceChecklistItemSaveResponseModel {
  ChecklistItemAnswerEntity? toEntity() =>
      data?.toEntity(mediaUrl: media?.url);
}

extension TaskOccurrenceListResponseModelToEntity
    on TaskOccurrenceListResponseModel {
  TaskOccurrenceListEntity toEntity() => TaskOccurrenceListEntity(
    occurrences: (data ?? []).map((m) => m.toEntity()).toList(),
    stats:
        stats?.toEntity() ??
        const TaskOccurrenceStatsEntity(
          totalSlots: 0,
          onTime: 0,
          late: 0,
          missed: 0,
          pending: 0,
          complianceScore: 0,
        ),
  );
}
