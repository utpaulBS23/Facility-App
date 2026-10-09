import 'package:dart_mappable/dart_mappable.dart';

import '../additional_income/additional_income_pagination_meta_model.dart';
import '../additional_income/named_ref_model.dart';

part 'cash_collection_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionServiceRefModel with CashCollectionServiceRefModelMappable {
  const CashCollectionServiceRefModel({
    this.id,
    this.serviceId,
    this.serviceName,
    this.section,
  });

  final int? id;
  final int? serviceId;
  final String? serviceName;
  final String? section;

  static const fromJson = CashCollectionServiceRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionItemModel with CashCollectionItemModelMappable {
  const CashCollectionItemModel({
    this.id,
    this.facilityService,
    this.gender,
    this.quantity,
    this.unitPrice,
    this.amount,
  });

  final int? id;
  final CashCollectionServiceRefModel? facilityService;
  final String? gender;
  final int? quantity;
  final double? unitPrice;
  final double? amount;

  static const fromJson = CashCollectionItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionModel with CashCollectionModelMappable {
  const CashCollectionModel({
    required this.id,
    this.facility,
    this.collectionDate,
    this.productSellingAmount,
    this.rentingOthersAmount,
    this.lineItemsTotal,
    this.totalCashAmount,
    this.items,
    this.photoUrl,
    this.note,
    this.submittedBy,
  });

  final int id;
  final NamedRefModel? facility;
  final String? collectionDate;
  final double? productSellingAmount;
  final double? rentingOthersAmount;
  final double? lineItemsTotal;
  final double? totalCashAmount;
  final List<CashCollectionItemModel>? items;
  final String? photoUrl;
  final String? note;
  final NamedRefModel? submittedBy;

  static const fromJson = CashCollectionModelMapper.fromJson;
}

// WHY a wrapper: the store/show response nests the record under `data`.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionResponseModel with CashCollectionResponseModelMappable {
  const CashCollectionResponseModel({this.data});

  final CashCollectionModel? data;

  static const fromJson = CashCollectionResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionSummaryModel with CashCollectionSummaryModelMappable {
  const CashCollectionSummaryModel({this.entriesCount, this.manualTotal});

  final int? entriesCount;
  final double? manualTotal;

  static const fromJson = CashCollectionSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class CashCollectionListResponseModel
    with CashCollectionListResponseModelMappable {
  const CashCollectionListResponseModel({this.data, this.meta, this.summary});

  final List<CashCollectionModel>? data;
  final AdditionalIncomePaginationMetaModel? meta;
  final CashCollectionSummaryModel? summary;

  static const fromJson = CashCollectionListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityServiceServiceModel with FacilityServiceServiceModelMappable {
  const FacilityServiceServiceModel({this.id, this.titleEn, this.titleBn});

  final int? id;
  final String? titleEn;
  final String? titleBn;

  static const fromJson = FacilityServiceServiceModelMapper.fromJson;
}

/// One row of `GET /partners/{p}/facilities/{f}/services` (a flat array).
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityServiceModel with FacilityServiceModelMappable {
  const FacilityServiceModel({
    required this.id,
    this.service,
    this.gender,
    this.price,
  });

  final int id;
  final FacilityServiceServiceModel? service;
  final String? gender;
  final double? price;

  static const fromJson = FacilityServiceModelMapper.fromJson;
}
