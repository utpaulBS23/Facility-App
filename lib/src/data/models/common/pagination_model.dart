import 'package:dart_mappable/dart_mappable.dart';

part 'pagination_model.mapper.dart';

/// The `pagination` envelope legacy (non-Laravel-resource) list endpoints
/// return — attendance today. See `meta`-based endpoints (tasks, issues,
/// visits, supply, ...) for the other shape, which each already has its own
/// per-feature meta model.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class PaginationModel with PaginationModelMappable {
  const PaginationModel({
    this.currentPage,
    this.totalPages,
    this.totalRecords,
    this.perPage,
  });

  final int? currentPage;
  final int? totalPages;
  final int? totalRecords;
  final int? perPage;

  static const fromJson = PaginationModelMapper.fromJson;
}
