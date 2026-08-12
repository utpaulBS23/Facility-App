import 'package:dart_mappable/dart_mappable.dart';

import 'delivery_model.dart';
import 'supply_pagination_meta_model.dart';

part 'delivery_response_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DeliveryResponseModel with DeliveryResponseModelMappable {
  const DeliveryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final DeliveryModel data;

  static const fromJson = DeliveryResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DeliveryListResponseModel with DeliveryListResponseModelMappable {
  const DeliveryListResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.meta,
  });

  final bool success;
  final String message;
  final List<DeliveryModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = DeliveryListResponseModelMapper.fromJson;
}
