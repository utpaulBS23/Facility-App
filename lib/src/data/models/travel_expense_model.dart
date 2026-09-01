import 'package:dart_mappable/dart_mappable.dart';

part 'travel_expense_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class TravelExpenseLegRequestModel with TravelExpenseLegRequestModelMappable {
  const TravelExpenseLegRequestModel({
    required this.vehicleTypeItemId,
    required this.distanceKm,
  });

  final int vehicleTypeItemId;
  final double distanceKm;
}

@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class CreateTravelExpenseRequestModel
    with CreateTravelExpenseRequestModelMappable {
  const CreateTravelExpenseRequestModel({
    this.taskId,
    this.facilityId,
    this.startType,
    this.startId,
    this.purpose,
    this.amount,
    required this.legs,
  });

  final int? taskId;
  final int? facilityId;
  final String? startType;
  final int? startId;
  final String? purpose;
  final double? amount;
  final List<TravelExpenseLegRequestModel> legs;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseLineModel with TravelExpenseLineModelMappable {
  const TravelExpenseLineModel({
    required this.id,
    this.vehicleTypeItemId,
    this.vehicleTypeLabel,
    this.distanceKm,
    this.amount,
  });

  final int id;
  final int? vehicleTypeItemId;
  final String? vehicleTypeLabel;
  final double? distanceKm;
  final double? amount;

  static const fromJson = TravelExpenseLineModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseModel with TravelExpenseModelMappable {
  const TravelExpenseModel({
    required this.id,
    this.taskId,
    this.facilityId,
    this.facilityName,
    this.purpose,
    this.calculatedDistanceKm,
    this.calculatedAmount,
    this.claimedDistanceKm,
    this.claimedAmount,
    this.ratePerKm,
    this.status,
    this.transportLines,
  });

  final int id;
  final int? taskId;
  final int? facilityId;
  final String? facilityName;
  final String? purpose;
  final double? calculatedDistanceKm;
  final double? calculatedAmount;
  final double? claimedDistanceKm;
  final double? claimedAmount;
  final double? ratePerKm;
  final String? status;
  final List<TravelExpenseLineModel>? transportLines;

  static const fromJson = TravelExpenseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseResponseModel with TravelExpenseResponseModelMappable {
  const TravelExpenseResponseModel({this.success, this.message, this.data});

  final bool? success;
  final String? message;
  final TravelExpenseModel? data;

  static const fromJson = TravelExpenseResponseModelMapper.fromJson;
}
