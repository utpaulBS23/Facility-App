import 'package:dart_mappable/dart_mappable.dart';

import 'shift_stock_count_model.dart';

part 'shift_stock_count_response_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ShiftStockCountListResponseModel
    with ShiftStockCountListResponseModelMappable {
  const ShiftStockCountListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<ShiftStockCountModel> data;

  static const fromJson = ShiftStockCountListResponseModelMapper.fromJson;
}
