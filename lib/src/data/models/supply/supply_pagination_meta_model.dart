import 'package:dart_mappable/dart_mappable.dart';

part 'supply_pagination_meta_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupplyPaginationMetaModel with SupplyPaginationMetaModelMappable {
  const SupplyPaginationMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static const fromJson = SupplyPaginationMetaModelMapper.fromJson;
}
