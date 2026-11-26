import 'package:dart_mappable/dart_mappable.dart';

part 'pagination_meta_model.mapper.dart';

/// The `meta` envelope Laravel-resource list endpoints return (tasks,
/// issues, visits, ...). See `pagination_model.dart` for the other shape
/// legacy endpoints (attendance) use instead.
///
/// WHY shared, not one per feature: several features already clone this
/// exact shape under their own name (`SupplyPaginationMetaModel`,
/// `ToiletPaginationMetaModel`, ...) — new consumers use this one instead of
/// adding yet another copy.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class PaginationMetaModel with PaginationMetaModelMappable {
  const PaginationMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static const fromJson = PaginationMetaModelMapper.fromJson;
}
