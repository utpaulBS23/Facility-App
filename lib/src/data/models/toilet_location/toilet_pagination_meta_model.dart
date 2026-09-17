import 'package:dart_mappable/dart_mappable.dart';

part 'toilet_pagination_meta_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletPaginationMetaModel with ToiletPaginationMetaModelMappable {
  const ToiletPaginationMetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static const fromJson = ToiletPaginationMetaModelMapper.fromJson;
}
