import 'package:dart_mappable/dart_mappable.dart';

part 'travel_expense_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class TravelExpenseLegRequestModel with TravelExpenseLegRequestModelMappable {
  const TravelExpenseLegRequestModel({
    required this.mode,
    required this.distanceKm,
    required this.ratePerKm,
  });

  final String mode;
  final double distanceKm;
  final double ratePerKm;
}

@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class CreateTravelExpenseRequestModel
    with CreateTravelExpenseRequestModelMappable {
  const CreateTravelExpenseRequestModel({
    required this.facilityId,
    this.visitId,
    required this.startLocation,
    required this.destination,
    required this.legs,
    required this.purpose,
  });

  final int facilityId;
  final int? visitId;
  final String startLocation;
  final String destination;
  final List<TravelExpenseLegRequestModel> legs;
  final String purpose;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseModel with TravelExpenseModelMappable {
  const TravelExpenseModel({
    required this.id,
    required this.totalDistanceKm,
    required this.totalAmount,
    this.status,
  });

  final int id;
  final double totalDistanceKm;
  final double totalAmount;
  final String? status;

  static const fromJson = TravelExpenseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseResponseModel with TravelExpenseResponseModelMappable {
  const TravelExpenseResponseModel({this.success, this.data});

  final bool? success;
  final TravelExpenseModel? data;

  static const fromJson = TravelExpenseResponseModelMapper.fromJson;
}
