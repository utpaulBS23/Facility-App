import '../../domain/entities/task_occurrence_entity.dart';
import '../models/task_occurrence_model.dart';

String _adjustTimeForTimezone(String? timeStr) {
  if (timeStr == null || timeStr.isEmpty) return timeStr ?? '';
  try {
    final parts = timeStr.trim().split(':');
    if (parts.isEmpty) return timeStr;

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts.length > 1 ? parts[1] : '0');
    final seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

    // Create a time and add 6 hours
    var adjustedHours = hours + 6;
    if (adjustedHours >= 24) {
      adjustedHours -= 24;
    }

    // Format back
    final hStr = adjustedHours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');

    if (parts.length > 2) {
      final sStr = seconds.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    return '$hStr:$mStr';
  } catch (_) {
    return timeStr;
  }
}

String _adjustTimeRangeForTimezone(String? timeRangeStr) {
  if (timeRangeStr == null || timeRangeStr.isEmpty) return timeRangeStr ?? '';
  try {
    // Split by separator (-, –, —, to)
    final parts = timeRangeStr.split(RegExp(r'\s*(?:[-–—~]|\bto\b)\s*'));
    if (parts.length != 2) return timeRangeStr;

    final adjustedStart = _adjustTimeForTimezone(parts[0].trim());
    final adjustedEnd = _adjustTimeForTimezone(parts[1].trim());

    return '$adjustedStart - $adjustedEnd';
  } catch (_) {
    return timeRangeStr;
  }
}

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
        response: response?.toEntity(mediaUrl: response?.photo?.url),
        proofRequiredOnComplete: proofRequiredOnComplete ?? false,
        proofPolicy: proofPolicy,
        isRequired: isRequired,
      );
}

extension TaskOccurrenceModelToEntity on TaskOccurrenceModel {
  TaskOccurrenceEntity toEntity() {
    final adjustedStart = _adjustTimeForTimezone(slotStart);
    final adjustedEnd = _adjustTimeForTimezone(slotEnd);

    return TaskOccurrenceEntity(
      id: id,
      taskScheduleId: taskScheduleId ?? 0,
      scheduleTitle: scheduleTitle ?? '',
      taskType: taskType ?? '',
      facilityId: facilityId ?? 0,
      occurrenceDate: occurrenceDate ?? '',
      slotStart: adjustedStart,
      slotEnd: adjustedEnd,
      timeRange: (timeRange != null && timeRange!.isNotEmpty)
          ? _adjustTimeRangeForTimezone(timeRange)!
          : (adjustedStart.isNotEmpty && adjustedEnd.isNotEmpty)
              ? '$adjustedStart - $adjustedEnd'
              : '',
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
