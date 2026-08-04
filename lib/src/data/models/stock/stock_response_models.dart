import 'package:dart_mappable/dart_mappable.dart';

import 'facility_stock_target_model.dart';
import 'shift_stock_count_model.dart';

part 'stock_response_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityStockTargetListResponseModel
    with FacilityStockTargetListResponseModelMappable {
  const FacilityStockTargetListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<FacilityStockTargetModel> data;

  static const fromJson = FacilityStockTargetListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ShiftStockCountListResponseModel
    with ShiftStockCountListResponseModelMappable {
  const ShiftStockCountListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<ShiftStockCountModel> data;

  static const fromJson = ShiftStockCountListResponseModelMapper.fromJson;
}
