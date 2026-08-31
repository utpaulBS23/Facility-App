import 'facility_stock_target_entity.dart';

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
