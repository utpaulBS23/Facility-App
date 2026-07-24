import 'package:dart_mappable/dart_mappable.dart';

import 'shift_model.dart';

part 'roster_shift_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterShiftModel with RosterShiftModelMappable {
  RosterShiftModel({
    required this.id,
    this.weeklyRosterId,
    required this.shiftTemplate,
    this.attendant,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    this.durationHours,
    this.status,
    this.notes,
    this.isOvertime,
  });

  final int id;
  @MappableField(key: 'weekly_roster_id')
  final int? weeklyRosterId;
  @MappableField(key: 'shift_template')
  final ShiftTemplateModel shiftTemplate;
  final ShiftAttendantModel? attendant;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  @MappableField(key: 'start_time')
  final String startTime;
  @MappableField(key: 'end_time')
  final String endTime;
  @MappableField(key: 'duration_hours')
  final String? durationHours;
  final String? status;
  final String? notes;
  @MappableField(key: 'is_overtime')
  final bool? isOvertime;

  static const fromJson = RosterShiftModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterShiftStatsModel with RosterShiftStatsModelMappable {
  RosterShiftStatsModel({
    this.totalShifts,
    this.assignedShifts,
    this.unassignedShifts,
  });

  @MappableField(key: 'total_shifts')
  final int? totalShifts;
  @MappableField(key: 'assigned_shifts')
  final int? assignedShifts;
  @MappableField(key: 'unassigned_shifts')
  final int? unassignedShifts;

  static const fromJson = RosterShiftStatsModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterShiftsResponseModel with RosterShiftsResponseModelMappable {
  RosterShiftsResponseModel({
    required this.success,
    this.message,
    this.data = const [],
    this.stats,
  });

  final bool success;
  final String? message;
  final List<RosterShiftModel> data;
  final RosterShiftStatsModel? stats;

  static const fromJson = RosterShiftsResponseModelMapper.fromJson;
}
