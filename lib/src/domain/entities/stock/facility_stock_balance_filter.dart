class FacilityStockBalanceFilter {
  const FacilityStockBalanceFilter({
    this.facilityId,
    this.partnerId,
    this.stockItemId,
    this.status,
    this.page = 1,
    this.perPage = 20,
  });

  final int? facilityId;
  final int? partnerId;
  final int? stockItemId;
  final String? status;
  final int page;
  final int perPage;

  FacilityStockBalanceFilter copyWith({
    int? facilityId,
    int? partnerId,
    int? stockItemId,
    String? status,
    int? page,
    int? perPage,
  }) {
    return FacilityStockBalanceFilter(
      facilityId: facilityId ?? this.facilityId,
      partnerId: partnerId ?? this.partnerId,
      stockItemId: stockItemId ?? this.stockItemId,
      status: status ?? this.status,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
