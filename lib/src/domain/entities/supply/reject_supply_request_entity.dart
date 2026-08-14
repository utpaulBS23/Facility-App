class RejectSupplyRequestEntity {
  const RejectSupplyRequestEntity({
    required this.supplyRequestId,
    this.notes,
  });

  final int supplyRequestId;
  final String? notes;
}
