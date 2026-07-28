import 'package:dart_mappable/dart_mappable.dart';

import 'shift_model.dart';

part 'roster_shift_model.mapper.dart';

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
  final List<ShiftModel> data;
  final RosterShiftStatsModel? stats;

  static const fromJson = RosterShiftsResponseModelMapper.fromJson;
}
