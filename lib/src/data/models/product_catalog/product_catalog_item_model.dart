import 'package:dart_mappable/dart_mappable.dart';

part 'product_catalog_item_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductCatalogItemModel with ProductCatalogItemModelMappable {
  const ProductCatalogItemModel({
    required this.id,
    this.name,
    this.nameBn,
    this.category,
    this.defaultPrice,
  });

  final int id;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;
  final String? category;
  final double? defaultPrice;

  static const fromJson = ProductCatalogItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductCatalogDropdownResponseModel
    with ProductCatalogDropdownResponseModelMappable {
  const ProductCatalogDropdownResponseModel({this.data});

  final List<ProductCatalogItemModel>? data;

  static const fromJson = ProductCatalogDropdownResponseModelMapper.fromJson;
}
