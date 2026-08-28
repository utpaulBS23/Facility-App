class SupplyRequestSummaryEntity {
  const SupplyRequestSummaryEntity({
    this.pending,
    this.approved,
    this.rejected,
    this.completed,
  });

  final int? pending;
  final int? approved;
  final int? rejected;
  final int? completed;
}

