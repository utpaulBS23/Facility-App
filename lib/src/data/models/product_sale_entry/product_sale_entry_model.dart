import 'package:dart_mappable/dart_mappable.dart';

part 'product_sale_entry_model.mapper.dart';

// WHY reuse-shaped, not NamedRefModel: facility/product/recorded_by here
// nest the same {id, name} pair as facility-expense's NamedRefModel, but
// product also carries `category` — kept as its own small model rather than
// widening the shared one for a field only this module needs.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductSaleEntryFacilityRefModel with ProductSaleEntryFacilityRefModelMappable {
  const ProductSaleEntryFacilityRefModel({required this.id, this.name});

  final int id;
  final String? name;

  static const fromJson = ProductSaleEntryFacilityRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductSaleEntryProductRefModel with ProductSaleEntryProductRefModelMappable {
  const ProductSaleEntryProductRefModel({required this.id, this.name, this.category});

  final int id;
  final String? name;
  final String? category;

  static const fromJson = ProductSaleEntryProductRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductSaleEntryRecordedByRefModel
    with ProductSaleEntryRecordedByRefModelMappable {
  const ProductSaleEntryRecordedByRefModel({required this.id, this.name});

  final int id;
  final String? name;

  static const fromJson = ProductSaleEntryRecordedByRefModelMapper.fromJson;
}

// WHY no separate wrapper for the row itself: this model IS the flat line
// item shape, nested one level under the response's top-level `data` key
// (a list, for both index rows and a store response) — see
// ProductSaleEntryListResponseModel below.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductSaleEntryModel with ProductSaleEntryModelMappable {
  const ProductSaleEntryModel({
    required this.id,
    this.facility,
    this.entryDate,
    this.product,
    this.unitsSold,
    this.unitPrice,
    this.revenue,
    this.profit,
    this.recordedBy,
    this.createdAt,
  });

  final int id;
  final ProductSaleEntryFacilityRefModel? facility;
  final String? entryDate;
  final ProductSaleEntryProductRefModel? product;
  final int? unitsSold;
  final double? unitPrice;
  final double? revenue;
  final double? profit;
  final ProductSaleEntryRecordedByRefModel? recordedBy;
  final String? createdAt;

  static const fromJson = ProductSaleEntryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProductSaleEntryListResponseModel
    with ProductSaleEntryListResponseModelMappable {
  const ProductSaleEntryListResponseModel({this.data});

  final List<ProductSaleEntryModel>? data;

  static const fromJson = ProductSaleEntryListResponseModelMapper.fromJson;
}
