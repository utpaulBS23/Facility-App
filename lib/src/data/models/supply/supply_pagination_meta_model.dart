import 'package:dart_mappable/dart_mappable.dart';

part 'supply_pagination_meta_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyPaginationMetaModel with SupplyPaginationMetaModelMappable {
  const SupplyPaginationMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  @MappableField(key: 'current_page')
  final int? currentPage;
  @MappableField(key: 'last_page')
  final int? lastPage;
  @MappableField(key: 'per_page')
  final int? perPage;
  final int? total;

  static const fromJson = SupplyPaginationMetaModelMapper.fromJson;
}
