class StockAllocationFilter {
  const StockAllocationFilter({
    this.facilityId,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? facilityId;
  final String? search;
  final int? page;
  final int? pageSize;
}
