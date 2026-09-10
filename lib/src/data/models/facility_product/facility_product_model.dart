import 'package:dart_mappable/dart_mappable.dart';

part 'facility_product_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityProductProductRefModel with FacilityProductProductRefModelMappable {
  const FacilityProductProductRefModel({required this.id, this.name, this.category});

  final int id;
  final String? name;
  final String? category;

  static const fromJson = FacilityProductProductRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityProductModel with FacilityProductModelMappable {
  const FacilityProductModel({
    required this.id,
    this.product,
    this.price,
    this.stockQuantity,
  });

  final int id;
  final FacilityProductProductRefModel? product;
  final double? price;
  final int? stockQuantity;

  static const fromJson = FacilityProductModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityProductListResponseModel with FacilityProductListResponseModelMappable {
  const FacilityProductListResponseModel({this.data});

  final List<FacilityProductModel>? data;

  static const fromJson = FacilityProductListResponseModelMapper.fromJson;
}
