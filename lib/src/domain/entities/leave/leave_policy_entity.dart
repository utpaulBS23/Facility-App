class LeavePolicyEntity {
  const LeavePolicyEntity({
    required this.id,
    required this.name,
    required this.leaveType,
    required this.defaultDaysPerYear,
    this.requiresApproval = true,
    this.canCarryForward = false,
  });

  final int id;
  final String name;
  final String leaveType;
  final double defaultDaysPerYear;
  final bool requiresApproval;
  final bool canCarryForward;
}
