import 'package:dart_mappable/dart_mappable.dart';

part 'submit_stock_count_request_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class StockCountItemModel with StockCountItemModelMappable {
  const StockCountItemModel({
    required this.stockItemId,
    required this.qtyOnHand,
    this.photoUrl,
  });

  final int stockItemId;
  final double qtyOnHand;
  final String? photoUrl;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class SubmitStockCountRequestModel with SubmitStockCountRequestModelMappable {
  const SubmitStockCountRequestModel({required this.items});

  final List<StockCountItemModel> items;
}
