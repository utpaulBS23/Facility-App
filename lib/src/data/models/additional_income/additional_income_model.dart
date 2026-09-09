import 'package:dart_mappable/dart_mappable.dart';

import 'additional_income_pagination_meta_model.dart';
import 'named_ref_model.dart';

part 'additional_income_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeSummaryModel with AdditionalIncomeSummaryModelMappable {
  const AdditionalIncomeSummaryModel({
    this.approvedTotal,
    this.pendingCount,
    this.totalSubmissions,
  });

  final double? approvedTotal;
  final int? pendingCount;
  final int? totalSubmissions;

  static const fromJson = AdditionalIncomeSummaryModelMapper.fromJson;
}

// WHY no separate wrapper for the record itself: this model IS the flat
// object nested one level under the response's top-level `data` key — see
// AdditionalIncomeResponseModel below for that wrapper.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeModel with AdditionalIncomeModelMappable {
  const AdditionalIncomeModel({
    required this.id,
    this.facility,
    this.incomeType,
    this.amount,
    this.description,
    this.evidencePhotoUrl,
    this.isSelfApproved,
    this.submittedBy,
    this.createdAt,
  });

  final int id;
  final NamedRefModel? facility;
  // WHY String not a nested object: the doc documents income_type as
  // {id, code, name, requires_photo}, but the real store response returns
  // it as a plain string (the master-data value, e.g. "rent_device") — same
  // stale-doc pattern as facility-expense's category field.
  final String? incomeType;
  final double? amount;
  final String? description;
  final String? evidencePhotoUrl;
  final bool? isSelfApproved;
  final NamedRefModel? submittedBy;
  final String? createdAt;

  static const fromJson = AdditionalIncomeModelMapper.fromJson;
}

// WHY a wrapper: unlike facility-expense's flat store/show response, the
// real additional-incomes store/show response nests the record under a
// top-level `data` key.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeResponseModel with AdditionalIncomeResponseModelMappable {
  const AdditionalIncomeResponseModel({this.data});

  final AdditionalIncomeModel? data;

  static const fromJson = AdditionalIncomeResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeListResponseModel
    with AdditionalIncomeListResponseModelMappable {
  const AdditionalIncomeListResponseModel({this.data, this.meta, this.summary});

  final List<AdditionalIncomeModel>? data;
  final AdditionalIncomePaginationMetaModel? meta;
  final AdditionalIncomeSummaryModel? summary;

  static const fromJson = AdditionalIncomeListResponseModelMapper.fromJson;
}
