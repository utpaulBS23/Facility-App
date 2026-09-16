/// One row from the partner/global product catalog dropdown
/// (`GET /partners/{partner}/product-catalog/dropdown`) — the source for the
/// "Select product" picker on the Product Sell flow.
class ProductCatalogItemEntity {
  const ProductCatalogItemEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultPrice,
  });

  final int id;
  final String name;
  final String category;
  final double defaultPrice;
}
