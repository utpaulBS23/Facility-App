class StockAveragingFilter {
  const StockAveragingFilter({
    this.facilityId,
    this.partnerId,
    this.page = 1,
    this.perPage = 20,
  });

  final int? facilityId;
  final int? partnerId;
  final int page;
  final int perPage;

  StockAveragingFilter copyWith({
    int? facilityId,
    int? partnerId,
    int? page,
    int? perPage,
  }) {
    return StockAveragingFilter(
      facilityId: facilityId ?? this.facilityId,
      partnerId: partnerId ?? this.partnerId,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
