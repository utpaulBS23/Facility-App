import '../../domain/entities/shift_entity.dart';
import '../models/roster_shift_model.dart';
import 'shift_mapper.dart';

extension RosterShiftStatsModelToEntity on RosterShiftStatsModel {
  RosterShiftStatsEntity toEntity() => RosterShiftStatsEntity(
    totalShifts: totalShifts ?? 0,
    assignedShifts: assignedShifts ?? 0,
    unassignedShifts: unassignedShifts ?? 0,
  );
}

extension RosterShiftsResponseModelToEntity on RosterShiftsResponseModel {
  RosterShiftsEntity toEntity() => RosterShiftsEntity(
    shifts: data.map((shift) => shift.toEntity()).toList(),
    stats: stats?.toEntity() ?? const RosterShiftStatsEntity(),
  );
}
