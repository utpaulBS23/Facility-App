import 'package:dart_mappable/dart_mappable.dart';

part 'incentive_fine_report_response_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class IncentiveFineReportResponseModel
    with IncentiveFineReportResponseModelMappable {
  const IncentiveFineReportResponseModel({
    this.achievementRate,
    this.statusLabel,
    this.target,
    this.totalIncome,
    this.facilities = const [],
    this.incentiveCalc,
    this.fineCalc,
  });

  final double? achievementRate;
  final String? statusLabel;
  final double? target;
  final double? totalIncome;
  final List<IncentiveFineFacilityModel> facilities;
  final IncentiveFineCalcModel? incentiveCalc;
  final IncentiveFineCalcModel? fineCalc;

  static const fromJson = IncentiveFineReportResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class IncentiveFineFacilityModel with IncentiveFineFacilityModelMappable {
  const IncentiveFineFacilityModel({
    this.facilityName,
    this.achievementRate,
    this.target,
    this.income,
  });

  final String? facilityName;
  final double? achievementRate;
  final double? target;
  final double? income;

  static const fromJson = IncentiveFineFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class IncentiveFineCalcModel with IncentiveFineCalcModelMappable {
  const IncentiveFineCalcModel({this.matchedBandLabel, this.amount});

  final String? matchedBandLabel;
  final double? amount;

  static const fromJson = IncentiveFineCalcModelMapper.fromJson;
}
