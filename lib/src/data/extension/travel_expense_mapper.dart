import '../../domain/entities/travel_expense_entity.dart';
import '../models/travel_expense_model.dart';

extension TravelExpenseLegEntityToModel on TravelExpenseLegEntity {
  TravelExpenseLegRequestModel toModel() => TravelExpenseLegRequestModel(
    vehicleTypeItemId: vehicleTypeItemId,
    distanceKm: distanceKm,
    ratePerKm: ratePerKm,
  );
}

extension CreateTravelExpenseRequestEntityToModel
    on CreateTravelExpenseRequestEntity {
  CreateTravelExpenseRequestModel toModel() => CreateTravelExpenseRequestModel(
    facilityId: facilityId,
    visitId: visitId,
    startLocation: startLocation,
    destination: destination,
    legs: legs.map((leg) => leg.toModel()).toList(),
    purpose: purpose,
  );
}

extension TravelExpenseModelToEntity on TravelExpenseModel {
  TravelExpenseEntity toEntity() => TravelExpenseEntity(
    id: id,
    totalDistanceKm: totalDistanceKm,
    totalAmount: totalAmount,
    status: status ?? '',
  );
}
