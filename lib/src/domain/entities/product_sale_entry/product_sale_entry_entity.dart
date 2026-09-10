/// One product-sale line item (`product_sale_entries` §3.5) — the response
/// shape for both `index` rows and each item in a `store` response array.
class ProductSaleEntryEntity {
  const ProductSaleEntryEntity({
    required this.id,
    required this.facilityName,
    required this.entryDate,
    required this.productName,
    required this.unitsSold,
    required this.unitPrice,
    required this.revenue,
    required this.profit,
    required this.recordedByName,
    required this.createdAt,
  });

  final int id;
  final String facilityName;
  final DateTime entryDate;
  final String productName;
  final int unitsSold;
  final double unitPrice;
  final double revenue;
  // WHY nullable: doc — `profit` is `null` when the product has no
  // `base_price` snapshot on file (SQL SUM ignores NULL terms upstream too).
  final double? profit;
  final String recordedByName;
  final DateTime createdAt;
}
