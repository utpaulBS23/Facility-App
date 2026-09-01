import 'package:dart_mappable/dart_mappable.dart';

import 'facility_stock_target_model.dart';

part 'facility_stock_target_detail_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockTargetDetailModel
    with FacilityStockTargetDetailModelMappable {
  const FacilityStockTargetDetailModel({
    required this.facilityId,
    required this.facilityName,
    required this.monthlyTotalDemandQty,
    this.targets = const [],
  });

  final int facilityId;
  final String facilityName;
  final double monthlyTotalDemandQty;
  final List<FacilityStockTargetModel> targets;

  static const fromJson = FacilityStockTargetDetailModelMapper.fromJson;
}
