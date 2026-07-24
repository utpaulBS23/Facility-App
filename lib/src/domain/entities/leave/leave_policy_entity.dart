class LeavePolicyEntity {
  const LeavePolicyEntity({
    required this.id,
    required this.partnerId,
    required this.name,
    required this.leaveType,
    required this.defaultDaysPerYear,
    this.maxConsecutiveDays,
    required this.requiresApproval,
    required this.canCarryForward,
    this.maxCarryForwardDays,
    this.minNoticeDays,
    this.color,
    this.description,
    required this.isActive,
  });

  final int id;
  final int partnerId;
  final String name;
  final String leaveType;
  final double defaultDaysPerYear;
  final int? maxConsecutiveDays;
  final bool requiresApproval;
  final bool canCarryForward;
  final double? maxCarryForwardDays;
  final int? minNoticeDays;
  final String? color;
  final String? description;
  final bool isActive;
}
