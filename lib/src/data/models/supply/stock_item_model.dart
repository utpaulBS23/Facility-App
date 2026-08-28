import 'package:dart_mappable/dart_mappable.dart';

part 'stock_item_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
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
  @MappableField(key: 'partner_id')
  final int? partnerId;
  @MappableField(key: 'partner_name')
  final String? partnerName;
  @MappableField(key: 'item_code')
  final String itemCode;
  final String name;
  final String category;
  final String unit;
  @MappableField(key: 'unit_price')
  final double unitPrice;
  @MappableField(key: 'is_active')
  final bool isActive;

  static const fromJson = StockItemModelMapper.fromJson;
}
