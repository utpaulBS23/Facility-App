/// One facility's row in the Stock Averaging list page.
///
/// WHY: the API has no per-facility summary endpoint/object — this is
/// derived client-side by grouping the flat target list (see
/// `StockAveragingListEntity`) by `facility_id`.
class FacilityStockAveragingOverviewEntity {
  const FacilityStockAveragingOverviewEntity({
    required this.facilityId,
    required this.facilityName,
    required this.itemCount,
    required this.monthlyTotalDemandQty,
  });

  final int facilityId;
  final String facilityName;
  final int itemCount;
  final double monthlyTotalDemandQty;
}
