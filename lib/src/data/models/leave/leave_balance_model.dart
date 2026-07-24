import 'package:dart_mappable/dart_mappable.dart';
import 'leave_policy_model.dart';

part 'leave_balance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveBalanceModel with LeaveBalanceModelMappable {
  const LeaveBalanceModel({
    required this.id,
    this.leavePolicy,
    this.year = 0,
    this.allocatedDays = 0.0,
    this.usedDays = 0.0,
    this.carriedForwardDays = 0.0,
    this.pendingDays = 0.0,
    this.adjustedDays = 0.0,
    this.totalAvailableDays = 0.0,
    this.remainingDays = 0.0,
    this.notes,
  });

  final int id;
  @MappableField(key: 'leave_policy')
  final LeavePolicyModel? leavePolicy;
  final int year;
  @MappableField(key: 'allocated_days', hook: StringToDoubleHook())
  final double allocatedDays;
  @MappableField(key: 'used_days', hook: StringToDoubleHook())
  final double usedDays;
  @MappableField(key: 'carried_forward_days', hook: StringToDoubleHook())
  final double carriedForwardDays;
  @MappableField(key: 'pending_days', hook: StringToDoubleHook())
  final double pendingDays;
  @MappableField(key: 'adjusted_days', hook: StringToDoubleHook())
  final double adjustedDays;
  @MappableField(key: 'total_available_days', hook: StringToDoubleHook())
  final double totalAvailableDays;
  @MappableField(key: 'remaining_days', hook: StringToDoubleHook())
  final double remainingDays;
  final String? notes;

  static const fromJson = LeaveBalanceModelMapper.fromJson;
}
