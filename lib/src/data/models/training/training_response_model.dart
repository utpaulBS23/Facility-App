import 'package:dart_mappable/dart_mappable.dart';

import '../supply/supply_pagination_meta_model.dart';
import 'training_models.dart';

part 'training_response_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TrainingSessionResponseModel with TrainingSessionResponseModelMappable {
  const TrainingSessionResponseModel({
    this.data,
  });

  final TrainingSessionModel? data;

  static const fromJson = TrainingSessionResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TrainingSessionListResponseModel with TrainingSessionListResponseModelMappable {
  const TrainingSessionListResponseModel({
    this.data = const [],
    this.meta,
  });

  final List<TrainingSessionModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = TrainingSessionListResponseModelMapper.fromJson;
}
