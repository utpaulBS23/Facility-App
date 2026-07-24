import '../../domain/entities/shift_entity.dart';
import '../models/roster_model.dart';

extension RosterFacilityModelToEntity on RosterFacilityModel {
  RosterFacilityEntity toEntity() =>
      RosterFacilityEntity(id: id, name: name ?? '', nameBn: nameBn);
}

extension RosterCreatorModelToEntity on RosterCreatorModel {
  RosterCreatorEntity toEntity() =>
      RosterCreatorEntity(id: id, fullName: fullName ?? '', role: role ?? '');
}

extension RosterDataModelToEntity on RosterDataModel {
  RosterEntity toEntity() => RosterEntity(
    id: id,
    facilityId: facilityId,
    facility: facility?.toEntity(),
    createdBy: createdBy?.toEntity(),
    weekStartDate: weekStartDate ?? '',
    weekEndDate: weekEndDate ?? '',
    status: status ?? '',
    publishedAt: publishedAt,
    totalShifts: totalShifts ?? 0,
    filledShifts: filledShifts ?? 0,
    notes: notes,
    offDays: offDays,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
