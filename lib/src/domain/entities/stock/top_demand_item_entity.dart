class TopDemandItemEntity {
  const TopDemandItemEntity({
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.totalMonthlyDemandQty,
  });

  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double totalMonthlyDemandQty;
}
