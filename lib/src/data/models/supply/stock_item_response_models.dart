import 'package:dart_mappable/dart_mappable.dart';

import 'stock_item_model.dart';
import 'supply_pagination_meta_model.dart';

part 'stock_item_response_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockItemListResponseModel with StockItemListResponseModelMappable {
  const StockItemListResponseModel({
    this.success,
    this.message,
    this.data = const [],
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<StockItemModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = StockItemListResponseModelMapper.fromJson;
}
