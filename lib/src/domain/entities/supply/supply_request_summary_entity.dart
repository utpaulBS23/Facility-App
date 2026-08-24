class SupplyRequestSummaryEntity {
  const SupplyRequestSummaryEntity({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.completed,
  });

  final String pending;
  final String approved;
  final String rejected;
  final String completed;
}
