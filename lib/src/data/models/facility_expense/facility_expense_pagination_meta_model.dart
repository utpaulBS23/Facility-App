import 'package:dart_mappable/dart_mappable.dart';

part 'facility_expense_pagination_meta_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityExpensePaginationMetaModel
    with FacilityExpensePaginationMetaModelMappable {
  const FacilityExpensePaginationMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static const fromJson = FacilityExpensePaginationMetaModelMapper.fromJson;
}
