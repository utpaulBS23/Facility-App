/// Filter for the product catalog dropdown
/// (`GET /partners/{partner}/product-catalog/dropdown`).
class ProductCatalogFilter {
  const ProductCatalogFilter({this.partnerId});

  final int? partnerId;

  ProductCatalogFilter copyWith({int? partnerId}) {
    return ProductCatalogFilter(partnerId: partnerId ?? this.partnerId);
  }
}
