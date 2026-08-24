import 'package:dart_mappable/dart_mappable.dart';

import 'supply_pagination_meta_model.dart';
import 'supply_request_model.dart';

part 'supply_response_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupplyRequestResponseModel with SupplyRequestResponseModelMappable {
  const SupplyRequestResponseModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final SupplyRequestModel? data;

  static const fromJson = SupplyRequestResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupplyRequestListResponseModel with SupplyRequestListResponseModelMappable {
  const SupplyRequestListResponseModel({
    this.success,
    this.message,
    this.data = const [],
    this.meta,
  });

  final bool? success;
  final String? message;
  final List<SupplyRequestModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = SupplyRequestListResponseModelMapper.fromJson;
}
