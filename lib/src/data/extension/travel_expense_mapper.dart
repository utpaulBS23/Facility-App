import '../../domain/entities/travel_expense_entity.dart';
import '../models/travel_expense_model.dart';

extension TravelExpenseLegEntityToModel on TravelExpenseLegEntity {
  TravelExpenseLegRequestModel toModel() => TravelExpenseLegRequestModel(
    vehicleTypeItemId: vehicleTypeItemId,
    distanceKm: distanceKm,
  );
}

extension _TravelExpenseStartTypeToWire on TravelExpenseStartType {
  String get wireValue => switch (this) {
    TravelExpenseStartType.facility => 'facility',
    TravelExpenseStartType.home => 'home',
    TravelExpenseStartType.office => 'office',
  };
}

extension CreateTravelExpenseRequestEntityToModel
    on CreateTravelExpenseRequestEntity {
  CreateTravelExpenseRequestModel toModel() => CreateTravelExpenseRequestModel(
    taskId: taskId,
    facilityId: taskId == null ? facilityId : null,
    startType: taskId == null ? startType?.wireValue : null,
    startId: taskId == null ? startId : null,
    purpose: purpose,
    amount: amount,
    legs: legs.map((leg) => leg.toModel()).toList(),
  );
}

extension TravelExpenseLineModelToEntity on TravelExpenseLineModel {
  TravelExpenseLineEntity toEntity() => TravelExpenseLineEntity(
    id: id,
    vehicleTypeItemId: vehicleTypeItemId ?? 0,
    vehicleTypeLabel: vehicleTypeLabel,
    distanceKm: distanceKm ?? 0,
    amount: amount ?? 0,
  );
}

extension TravelExpenseModelToEntity on TravelExpenseModel {
  TravelExpenseEntity toEntity() => TravelExpenseEntity(
    id: id,
    taskId: taskId,
    facilityId: facilityId,
    facilityName: facilityName,
    purpose: purpose,
    calculatedDistanceKm: calculatedDistanceKm,
    calculatedAmount: calculatedAmount,
    claimedDistanceKm: claimedDistanceKm,
    claimedAmount: claimedAmount,
    ratePerKm: ratePerKm,
    status: status ?? '',
    transportLines:
        transportLines?.map((line) => line.toEntity()).toList() ?? const [],
  );
}
