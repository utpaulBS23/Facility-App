class LeaveSummaryEntity {
  const LeaveSummaryEntity({
    this.pending,
    this.managerApproval,
    this.approved,
    this.rejected,
  });

  final int? pending;
  final int? managerApproval;
  final int? approved;
  final int? rejected;
}
