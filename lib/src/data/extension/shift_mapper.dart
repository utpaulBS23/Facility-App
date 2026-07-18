import '../models/shift_model.dart';
import '../../domain/entities/shift_entity.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    // WHY: API returns UTC strings without 'Z' suffix; Dart parses bare
    // ISO strings as local time, so we force UTC before converting.
    final s =
        (raw.contains('Z') || raw.contains('+')) ? raw : '${raw}Z';
    return DateTime.parse(s).toLocal();
  } catch (_) {
    return null;
  }
}

extension ShiftSupervisorModelToEntity on ShiftSupervisorModel {
  ShiftSupervisorEntity toEntity() => ShiftSupervisorEntity(
        id: id,
        fullName: fullName ?? '',
        phone: phone,
        isPrimary: isPrimary ?? false,
      );
}

extension ShiftFacilityModelToEntity on ShiftFacilityModel {
  ShiftFacilityEntity toEntity() => ShiftFacilityEntity(
        id: id,
        name: name ?? '',
        address: address ?? '',
        supervisor: supervisor?.toEntity(),
      );
}

extension ShiftAttendantModelToEntity on ShiftAttendantModel {
  ShiftAttendantEntity toEntity() => ShiftAttendantEntity(
        id: id,
        fullName: fullName ?? '',
        phone: phone,
      );
}

extension ShiftAssignmentModelToEntity on ShiftAssignmentModel {
  /// WHY: callers must filter out assignments with a null [attendant] first —
  /// an assignment without one is meaningless, and fabricating a placeholder
  /// attendant would put a phantom person in the assigned list.
  ShiftAssignmentEntity toEntity() => ShiftAssignmentEntity(
        id: id,
        attendant: attendant!.toEntity(),
        isSlotLead: isSlotLead ?? false,
        assignedAt: assignedAt,
        unassignedAt: unassignedAt,
        unassignedReason: unassignedReason,
      );
}

extension ShiftModelToEntity on ShiftModel {
  ShiftEntity toEntity() => ShiftEntity(
        id: id,
        weeklyRosterId: weeklyRosterId,
        shiftTemplateId: shiftTemplate.id,
        facility: facility.toEntity(),
        shiftTemplateName: shiftTemplate.name ?? '',
        shiftDate: shiftDate,
        startTime: startTime,
        endTime: endTime,
        status: status ?? '',
        checkInTime: _parseUtcIso(checkInTime),
        checkOutTime: _parseUtcIso(checkOutTime),
        notes: notes,
        assignments: assignments
            .where((a) => a.attendant != null)
            .map((a) => a.toEntity())
            .toList(),
        attendant: attendant?.toEntity(),
        isSlotLead: isSlotLead ?? false,
        minAttendants: minAttendants ?? 0,
        maxAttendants: maxAttendants ?? 0,
        assignedCount: assignedCount ?? 0,
        checkedInCount: checkedInCount ?? 0,
        checkedOutCount: checkedOutCount ?? 0,
        slotStatus: slotStatus ?? '',
      );
}
