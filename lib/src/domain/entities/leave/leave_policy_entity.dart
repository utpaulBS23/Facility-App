import 'leave_type.dart';

class LeavePolicyEntity {
  const LeavePolicyEntity({
    required this.id,
    required this.name,
    required this.leaveType,
    required this.defaultDaysPerYear,
    required this.requiresApproval,
    required this.canCarryForward,
  });

  final int id;
  final String name;
  final LeaveType leaveType;
  final double defaultDaysPerYear;
  final bool requiresApproval;
  final bool canCarryForward;
}
