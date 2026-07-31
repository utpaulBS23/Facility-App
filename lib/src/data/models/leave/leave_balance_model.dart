import 'package:dart_mappable/dart_mappable.dart';

import 'leave_policy_model.dart';

part 'leave_balance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveBalanceModel with LeaveBalanceModelMappable {
  const LeaveBalanceModel({
    required this.id,
    this.leavePolicy,
    this.year,
    this.allocatedDays,
    this.usedDays,
    this.carriedForwardDays,
    this.pendingDays,
    this.adjustedDays,
    this.totalAvailableDays,
    this.remainingDays,
    this.notes,
  });

  final int id;
  @MappableField(key: 'leave_policy')
  final LeavePolicyModel? leavePolicy;
  final int? year;
  @MappableField(key: 'allocated_days', hook: StringToNullableDoubleHook())
  final double? allocatedDays;
  @MappableField(key: 'used_days', hook: StringToNullableDoubleHook())
  final double? usedDays;
  @MappableField(key: 'carried_forward_days', hook: StringToNullableDoubleHook())
  final double? carriedForwardDays;
  @MappableField(key: 'pending_days', hook: StringToNullableDoubleHook())
  final double? pendingDays;
  @MappableField(key: 'adjusted_days', hook: StringToNullableDoubleHook())
  final double? adjustedDays;
  @MappableField(key: 'total_available_days', hook: StringToNullableDoubleHook())
  final double? totalAvailableDays;
  @MappableField(key: 'remaining_days', hook: StringToNullableDoubleHook())
  final double? remainingDays;
  final String? notes;

  static const fromJson = LeaveBalanceModelMapper.fromJson;
}
