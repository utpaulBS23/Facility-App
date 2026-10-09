/// Filter query parameters for the cash collections list
/// (`GET /partners/{partner}/cash-collections`).
class CashCollectionFilter {
  const CashCollectionFilter({
    this.partnerId,
    this.facilityId,
    this.month,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;

  /// `yyyy-MM`.
  final String? month;
  final int? page;
  final int? pageSize;

  CashCollectionFilter copyWith({
    int? partnerId,
    int? facilityId,
    String? month,
    int? page,
    int? pageSize,
  }) {
    return CashCollectionFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      month: month ?? this.month,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
