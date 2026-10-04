import 'facility_stock_target_entity.dart';
import '../../../core/utils/localized_text.dart';

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
    this.facilityNameBn = '',
    required this.monthlyTotalDemandQty,
    required this.targets,
  });

  final int facilityId;
  final String facilityName;
  final String facilityNameBn;
  final double monthlyTotalDemandQty;
  final List<FacilityStockTargetEntity> targets;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}
