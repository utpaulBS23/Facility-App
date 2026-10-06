import 'package:dart_mappable/dart_mappable.dart';

part 'facility_wise_report_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityWiseSummaryModel with FacilityWiseSummaryModelMappable {
  const FacilityWiseSummaryModel({
    this.totalIncome,
    this.totalExpense,
    this.convertedBkashBank,
    this.cashBalance,
  });

  final num? totalIncome;
  final num? totalExpense;
  final num? convertedBkashBank;
  final num? cashBalance;

  static const fromJson = FacilityWiseSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityWiseRowModel with FacilityWiseRowModelMappable {
  const FacilityWiseRowModel({
    this.facilityId,
    this.facilityName,
    this.groupCode,
    this.income,
    this.accountsPaid,
    this.operationDepartment,
    this.expense,
    this.toBkash,
    this.toBank,
    this.cashBalance,
    this.profitLoss,
    this.monthClosed,
  });

  final int? facilityId;
  final String? facilityName;
  final String? groupCode;
  final num? income;
  final num? accountsPaid;
  final num? operationDepartment;
  final num? expense;
  final num? toBkash;
  final num? toBank;
  final num? cashBalance;
  final num? profitLoss;
  final bool? monthClosed;

  static const fromJson = FacilityWiseRowModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityWiseReportResponseModel
    with FacilityWiseReportResponseModelMappable {
  const FacilityWiseReportResponseModel({
    this.summary,
    this.facilities = const [],
  });

  final FacilityWiseSummaryModel? summary;
  final List<FacilityWiseRowModel> facilities;

  static const fromJson = FacilityWiseReportResponseModelMapper.fromJson;
}
