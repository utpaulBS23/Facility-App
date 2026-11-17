import 'package:dart_mappable/dart_mappable.dart';

part 'travel_expense_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class TravelExpenseLegRequestModel with TravelExpenseLegRequestModelMappable {
  const TravelExpenseLegRequestModel({
    required this.vehicleTypeItemId,
    required this.distanceKm,
    this.amount,
  });

  final int vehicleTypeItemId;
  final double distanceKm;

  /// Client override of this leg's server-computed amount. Omit to let the
  /// server use `distance_km × rate_per_km`.
  final double? amount;
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
    this.claimedAmount,
  });

  final int id;
  final int? vehicleTypeItemId;
  final String? vehicleTypeLabel;
  final double? distanceKm;

  /// Server-computed: `distance_km × rate_per_km`.
  final double? amount;

  /// The amount actually claimed for this line — equals [amount] unless the
  /// user overrode it via `legs[].amount` on create.
  final double? claimedAmount;

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
    this.facilityNameBn,
    this.officeId,
    this.officeName,
    this.officeNameBn,
    this.userId,
    this.startType,
    this.startId,
    this.userName,
    this.userNameBn,
    this.purpose,
    this.calculatedDistanceKm,
    this.calculatedAmount,
    this.claimedDistanceKm,
    this.claimedAmount,
    this.ratePerKm,
    this.status,
    this.transportLines,
    this.submittedAt,
    this.rejectionNote,
    this.approvedAmount,
    this.adjustmentReason,
  });

  final int id;
  final int? taskId;
  final int? facilityId;
  final String? facilityName;
  @MappableField(key: 'facility_name_bn')
  final String? facilityNameBn;
  final int? officeId;
  final String? officeName;
  @MappableField(key: 'office_name_bn')
  final String? officeNameBn;
  final int? userId;
  final String? startType;
  final int? startId;
  final String? userName;
  @MappableField(key: 'user_name_bn')
  final String? userNameBn;
  final String? purpose;
  final double? calculatedDistanceKm;
  final double? calculatedAmount;
  final double? claimedDistanceKm;
  final double? claimedAmount;
  final double? ratePerKm;
  final String? status;
  final List<TravelExpenseLineModel>? transportLines;
  final String? submittedAt;
  final String? rejectionNote;
  final double? approvedAmount;
  final String? adjustmentReason;

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

/// `GET /travel-expenses` — Laravel's standard paginated shape, `links`/`meta`
/// deliberately not modeled: the list is fetched one `per_page=100` page and
/// treated as the full set for now, see `GetTravelExpensesUseCase`.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TravelExpenseListResponseModel
    with TravelExpenseListResponseModelMappable {
  const TravelExpenseListResponseModel({this.data = const []});

  final List<TravelExpenseModel> data;

  static const fromJson = TravelExpenseListResponseModelMapper.fromJson;
}
