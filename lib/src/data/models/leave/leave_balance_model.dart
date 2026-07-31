import 'package:dart_mappable/dart_mappable.dart';

import 'leave_policy_model.dart';

part 'leave_balance_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final LeavePolicyModel? leavePolicy;
  final int? year;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? allocatedDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? usedDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? carriedForwardDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? pendingDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? adjustedDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? totalAvailableDays;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? remainingDays;
  final String? notes;

  static const fromJson = LeaveBalanceModelMapper.fromJson;
}
