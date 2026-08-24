import 'package:dart_mappable/dart_mappable.dart';

part 'stock_item_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class StockItemModel with StockItemModelMappable {
  const StockItemModel({
    required this.id,
    this.partnerId,
    this.partnerName,
    required this.itemCode,
    required this.name,
    required this.category,
    required this.unit,
    required this.unitPrice,
    required this.isActive,
  });

  final int id;
  final int? partnerId;
  final String? partnerName;
  final String itemCode;
  final String name;
  final String category;
  final String unit;
  final double unitPrice;
  final bool isActive;

  static const fromJson = StockItemModelMapper.fromJson;
}
