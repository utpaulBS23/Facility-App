import '../models/shift_model.dart';
import '../../domain/entities/shift_entity.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return DateTime.parse(raw).toLocal();
  } catch (_) {
    return null;
  }
}

extension ShiftSupervisorModelToEntity on ShiftSupervisorModel {
  ShiftSupervisorEntity toEntity() => ShiftSupervisorEntity(
        id: id,
        fullName: fullName ?? '',
        phone: phone,
        isPrimary: (isPrimary ?? 0) == 1,
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
        status: status,
        checkInTime: _parseUtcIso(checkInTime),
        checkOutTime: _parseUtcIso(checkOutTime),
        notes: notes,
        attendants: attendants.map((a) => a.toEntity()).toList(),
      );
}
