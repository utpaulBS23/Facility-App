/// Filter query parameters for product sale entries list
/// (`GET /partners/{partner}/product-sale-entries`).
class ProductSaleEntryFilter {
  const ProductSaleEntryFilter({
    this.partnerId,
    this.facilityId,
    this.month,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;

  /// `yyyy-MM` — when set, overrides `from`/`to` server-side entirely (this
  /// app never sends `from`/`to`, only ever a single month at a time).
  final String? month;
  final int? page;
  final int? pageSize;

  ProductSaleEntryFilter copyWith({
    int? partnerId,
    int? facilityId,
    String? month,
    int? page,
    int? pageSize,
  }) {
    return ProductSaleEntryFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      month: month ?? this.month,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
