import 'facility_stock_target_entity.dart';

/// One facility's full set of stock-averaging targets, for the edit screen.
///
/// WHY: no dedicated per-facility endpoint exists — this is built client-side
/// from the same flat list the overview page uses (`StockAveragingListEntity`),
/// filtered to one `facility_id`. `monthlyTotalDemandQty` is a local sum, not
/// an API-provided figure.
class FacilityStockTargetDetailEntity {
  const FacilityStockTargetDetailEntity({
    required this.facilityId,
    required this.facilityName,
    required this.monthlyTotalDemandQty,
    required this.targets,
  });

  final int facilityId;
  final String facilityName;
  final double monthlyTotalDemandQty;
  final List<FacilityStockTargetEntity> targets;
}
