import 'leave_type.dart';

class LeavePolicyEntity {
  const LeavePolicyEntity({
    required this.id,
    required this.name,
    required this.leaveType,
    this.defaultDaysPerYear,
    this.requiresApproval,
    this.canCarryForward,
  });

  final int id;
  final String name;
  final LeaveType leaveType;
  final double? defaultDaysPerYear;
  final bool? requiresApproval;
  final bool? canCarryForward;
}
