class CreateLeaveRequest {
  const CreateLeaveRequest({
    required this.leavePolicyId,
    required this.startDate,
    required this.endDate,
    this.attendantId,
    this.reason,
    this.coverAttendantId,
    this.attachments = const [],
  });

  final int leavePolicyId;
  final String startDate;
  final String endDate;
  final int? attendantId;
  final String? reason;
  final int? coverAttendantId;
  final List<String> attachments;
}
