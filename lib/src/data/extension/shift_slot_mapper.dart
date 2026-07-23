import '../../domain/entities/shift_slot_entity.dart';
import '../models/shift_slot_model.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    // WHY: API returns UTC strings without a 'Z' suffix; Dart parses bare ISO
    // strings as local time, so force UTC before converting.
    final value = (raw.contains('Z') || raw.contains('+')) ? raw : '${raw}Z';
    return DateTime.parse(value).toLocal();
  } catch (_) {
    return null;
  }
}

extension SlotFacilityModelToEntity on SlotFacilityModel {
  SlotFacilityEntity toEntity() =>
      SlotFacilityEntity(id: id, name: name ?? '');
}

extension SlotAttendanceModelToEntity on SlotAttendanceModel {
  SlotAttendanceEntity toEntity() => SlotAttendanceEntity(
    id: id,
    checkInTime: _parseUtcIso(checkInTime),
    checkOutTime: _parseUtcIso(checkOutTime),
    approvalStatus: approvalStatus ?? '',
    lateByMinutes: lateByMinutes ?? 0,
    checkInDistanceMeters: checkInDistanceMeters,
    checkInSelfieUrl: checkInSelfieUrl,
    checkOutSelfieUrl: checkOutSelfieUrl,
  );
}

extension SlotAttendantModelToEntity on SlotAttendantModel {
  SlotAttendantEntity toEntity() => SlotAttendantEntity(
    userId: userId,
    name: name ?? '',
    staffCode: staffCode ?? '',
    isSlotLead: isSlotLead ?? false,
    isMe: isMe ?? false,
    action: SlotAction.fromKey(action),
    attendance: attendance?.toEntity(),
    earlyWindowOpens: earlyWindowOpens,
    lateCheckinDeadline: lateCheckinDeadline,
    // WHY: the key is only present once someone is taken off the slot, so its
    // absence means still assigned.
    isUnassigned: unassigned ?? false,
    unassignedReason: unassignedReason,
  );
}

extension ShiftSlotModelToEntity on ShiftSlotModel {
  ShiftSlotEntity toEntity() => ShiftSlotEntity(
    shiftSlotId: shiftSlotId,
    startTime: startTime ?? '',
    endTime: endTime ?? '',
    durationHours: durationHours ?? 0,
    slotStatus: slotStatus ?? '',
    assignedCount: assignedCount ?? 0,
    maxAttendants: maxAttendants ?? 0,
    checkedInCount: checkedInCount ?? 0,
    checkedOutCount: checkedOutCount ?? 0,
    attendants: attendants.map((a) => a.toEntity()).toList(),
  );
}

extension ActiveSlotModelToEntity on ActiveSlotModel {
  ActiveSlotEntity toEntity() => ActiveSlotEntity(
    shiftSlotId: shiftSlotId,
    startTime: startTime ?? '',
    endTime: endTime ?? '',
    action: SlotAction.fromKey(action),
    isSlotLead: isSlotLead ?? false,
    message: message ?? '',
  );
}

extension SlotSummaryModelToEntity on SlotSummaryModel {
  SlotSummaryEntity toEntity() => SlotSummaryEntity(
    totalSlots: totalSlots ?? 0,
    inProgress: inProgress ?? 0,
    open: open ?? 0,
    missed: missed ?? 0,
    totalAssigned: totalAssigned ?? 0,
    totalCheckedIn: totalCheckedIn ?? 0,
  );
}

extension ShiftSlotsDataModelToEntity on ShiftSlotsDataModel {
  ShiftSlotsEntity toEntity() => ShiftSlotsEntity(
    date: date ?? '',
    day: day ?? '',
    facility: facility?.toEntity(),
    activeSlot: activeSlot?.toEntity(),
    slots: slots.map((s) => s.toEntity()).toList(),
    summary: summary?.toEntity(),
  );
}
