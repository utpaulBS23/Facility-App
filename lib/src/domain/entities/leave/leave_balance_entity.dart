import 'leave_policy_entity.dart';

class LeaveBalanceEntity {
  const LeaveBalanceEntity({
    required this.id,
    this.leavePolicy,
    required this.year,
    required this.allocatedDays,
    required this.usedDays,
    required this.carriedForwardDays,
    required this.pendingDays,
    required this.adjustedDays,
    required this.totalAvailableDays,
    required this.remainingDays,
    this.notes,
  });

  final int id;
  final LeavePolicyEntity? leavePolicy;
  final int year;
  final double allocatedDays;
  final double usedDays;
  final double carriedForwardDays;
  final double pendingDays;
  final double adjustedDays;
  final double totalAvailableDays;
  final double remainingDays;
  final String? notes;
}
