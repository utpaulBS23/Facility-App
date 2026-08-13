class StockItemEntity {
  const StockItemEntity({
    required this.id,
    required this.itemCode,
    required this.name,
    required this.category,
    required this.unit,
    required this.isActive,
  });

  final int id;
  final String itemCode;
  final String name;
  final String category;
  final String unit;
  final bool isActive;
}
