class CreateSupplyRequestItemEntity {
  const CreateSupplyRequestItemEntity({
    required this.stockItemId,
    required this.qtyRequested,
    this.unitPrice,
  });

  final int stockItemId;
  final double qtyRequested;
  final double? unitPrice;
}
