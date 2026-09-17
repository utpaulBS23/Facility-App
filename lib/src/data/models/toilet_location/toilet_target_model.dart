import 'package:dart_mappable/dart_mappable.dart';

part 'toilet_target_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletTargetModel with ToiletTargetModelMappable {
  const ToiletTargetModel({
    required this.facilityId,
    required this.facilityName,
    this.supervisorName,
    required this.targetRevenue,
    this.actualRevenue,
    this.targetProfit,
    this.targetAttendancePct,
    this.targetCompliancePct,
  });

  final int facilityId;
  final String facilityName;
  final String? supervisorName;
  final double targetRevenue;
  final double? actualRevenue;
  final double? targetProfit;
  final double? targetAttendancePct;
  final double? targetCompliancePct;

  static const fromJson = ToiletTargetModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletTargetListResponseModel with ToiletTargetListResponseModelMappable {
  const ToiletTargetListResponseModel({
    this.data = const [],
  });

  final List<ToiletTargetModel> data;

  static const fromJson = ToiletTargetListResponseModelMapper.fromJson;
}
