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

// WHY nested income_type object with its own model: unlike facility-expense's
// category (a plain master-data value string), the doc's additional-income
// response nests income_type as {id, code, name, requires_photo}.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeTypeRefModel with AdditionalIncomeTypeRefModelMappable {
  const AdditionalIncomeTypeRefModel({
    required this.id,
    this.code,
    this.name,
    this.requiresPhoto,
  });

  final int id;
  final String? code;
  final String? name;
  final bool? requiresPhoto;

  static const fromJson = AdditionalIncomeTypeRefModelMapper.fromJson;
}

// WHY no separate wrapper: matches facility-expense's flat store/show model
// — no `data` wrapper at the top level of a single record response.
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
  final AdditionalIncomeTypeRefModel? incomeType;
  final double? amount;
  final String? description;
  final String? evidencePhotoUrl;
  final bool? isSelfApproved;
  final NamedRefModel? submittedBy;
  final String? createdAt;

  static const fromJson = AdditionalIncomeModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class AdditionalIncomeListResponseModel
    with AdditionalIncomeListResponseModelMappable {
  const AdditionalIncomeListResponseModel({
    this.data = const [],
    this.meta,
    this.summary,
  });

  final List<AdditionalIncomeModel> data;
  final AdditionalIncomePaginationMetaModel? meta;
  final AdditionalIncomeSummaryModel? summary;

  static const fromJson = AdditionalIncomeListResponseModelMapper.fromJson;
}
