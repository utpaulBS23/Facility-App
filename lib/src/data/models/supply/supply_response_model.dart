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
class SupplyRequestSummaryModel with SupplyRequestSummaryModelMappable {
  const SupplyRequestSummaryModel({
    this.pending,
    this.approved,
    this.rejected,
    this.completed,
  });

  final int? pending;
  final int? approved;
  final int? rejected;
  final int? completed;

  static const fromJson = SupplyRequestSummaryModelMapper.fromJson;
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
    this.summary,
  });

  final bool? success;
  final String? message;
  final List<SupplyRequestModel> data;
  final SupplyPaginationMetaModel? meta;
  final SupplyRequestSummaryModel? summary;

  static const fromJson = SupplyRequestListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupplyRequestSummaryResponseModel with SupplyRequestSummaryResponseModelMappable {
  const SupplyRequestSummaryResponseModel({
    this.success,
    this.message,
    this.summary,
  });

  final bool? success;
  final String? message;
  final SupplyRequestSummaryModel? summary;

  static const fromJson = SupplyRequestSummaryResponseModelMapper.fromJson;
}
