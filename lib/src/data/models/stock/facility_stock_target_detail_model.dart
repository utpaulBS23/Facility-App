import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../extension/facility_stock_target_mapper.dart';
import 'facility_stock_target_model.dart';

part 'facility_stock_target_detail_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityStockTargetDetailModel with FacilityStockTargetDetailModelMappable {
  FacilityStockTargetDetailModel({
    @MappableField(key: 'facility_id') required this.facilityId,
    @MappableField(key: 'facility_name') required this.facilityName,
    @MappableField(key: 'monthly_total_demand_qty') required this.monthlyTotalDemandQty,
    this.targets = const [],
  });

  final int facilityId;
  final String facilityName;
  final double monthlyTotalDemandQty;
  final List<FacilityStockTargetModel> targets;

  static const fromJson = FacilityStockTargetDetailModelMapper.fromJson;

  FacilityStockTargetDetailEntity toEntity() {
    return FacilityStockTargetDetailEntity(
      facilityId: facilityId,
      facilityName: facilityName,
      monthlyTotalDemandQty: monthlyTotalDemandQty,
      targets: targets.map((t) => t.toEntity()).toList(),
    );
  }
}
