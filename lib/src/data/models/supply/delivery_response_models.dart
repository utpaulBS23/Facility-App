import 'package:dart_mappable/dart_mappable.dart';

import 'delivery_model.dart';
import 'supply_pagination_meta_model.dart';

part 'delivery_response_models.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class DeliveryResponseModel with DeliveryResponseModelMappable {
  const DeliveryResponseModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final DeliveryModel? data;

  static const fromJson = DeliveryResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class DeliveryListResponseModel with DeliveryListResponseModelMappable {
  const DeliveryListResponseModel({
    this.success,
    this.message,
    this.data = const [],
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<DeliveryModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = DeliveryListResponseModelMapper.fromJson;
}
