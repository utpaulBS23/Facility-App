import '../models/shift_model.dart';
import '../../domain/entities/shift_entity.dart';

extension ShiftSupervisorModelToEntity on ShiftSupervisorModel {
  ShiftSupervisorEntity toEntity() => ShiftSupervisorEntity(
        id: id,
        fullName: fullName,
        phone: phone,
        isPrimary: isPrimary == 1,
      );
}

extension ShiftFacilityModelToEntity on ShiftFacilityModel {
  ShiftFacilityEntity toEntity() => ShiftFacilityEntity(
        id: id,
        name: name,
        address: address,
        supervisors: supervisors.map((s) => s.toEntity()).toList(),
      );
}

extension ShiftModelToEntity on ShiftModel {
  ShiftEntity toEntity() => ShiftEntity(
        id: id,
        facility: facility.toEntity(),
        shiftTemplateName: shiftTemplate.name,
        shiftDate: shiftDate,
        startTime: startTime,
        endTime: endTime,
        status: status,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        notes: notes,
      );
}
