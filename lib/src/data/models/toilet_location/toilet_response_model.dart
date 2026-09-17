import 'package:dart_mappable/dart_mappable.dart';

import 'toilet_model.dart';
import 'toilet_pagination_meta_model.dart';

part 'toilet_response_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletListResponseModel with ToiletListResponseModelMappable {
  const ToiletListResponseModel({
    this.data = const [],
    this.meta,
    this.summary,
  });

  final List<ToiletModel> data;
  final ToiletPaginationMetaModel? meta;
  final ToiletSummaryModel? summary;

  static const fromJson = ToiletListResponseModelMapper.fromJson;
}
