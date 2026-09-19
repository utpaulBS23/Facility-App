/// One row from the facility-scoped product offering list
/// (`GET /partners/{partner}/facility-products?facility_id=...`) — the source
/// for the "Select product" picker on the Product Sell flow, since a product
/// must be currently offered at the selected facility to be sold there.
class FacilityProductEntity {
  const FacilityProductEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.price,
    required this.stockQuantity,
  });

  final int id;
  final int productId;
  final String productName;
  final String category;
  final double price;
  final int stockQuantity;
}
