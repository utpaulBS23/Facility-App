import 'leave_policy_entity.dart';

class LeaveBalanceEntity {
  const LeaveBalanceEntity({
    required this.id,
    this.leavePolicy,
    required this.allocatedDays,
    required this.usedDays,
    required this.pendingDays,
    required this.remainingDays,
  });

  final int id;
  final LeavePolicyEntity? leavePolicy;
  final double allocatedDays;
  final double usedDays;
  final double pendingDays;
  final double remainingDays;
}
