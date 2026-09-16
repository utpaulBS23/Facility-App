import '../../domain/entities/travel_expense_entity.dart';
import '../../domain/entities/travel_expense_status.dart';
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
    vehicleTypeLabel: vehicleTypeLabel ?? '',
  );
}

extension TravelExpenseModelToEntity on TravelExpenseModel {
  TravelExpenseEntity toEntity() => TravelExpenseEntity(
    id: id,
    facilityName: facilityName ?? '',
    userName: userName ?? '',
    purpose: purpose ?? '',
    claimedDistanceKm: claimedDistanceKm ?? 0,
    claimedAmount: claimedAmount ?? 0,
    status: TravelExpenseStatus.fromWireString(status),
    submittedAt: submittedAt ?? '',
    rejectionNote: rejectionNote ?? '',
    transportLines:
        transportLines?.map((line) => line.toEntity()).toList() ?? const [],
  );
}

extension TravelExpenseListResponseModelToEntity
    on TravelExpenseListResponseModel {
  List<TravelExpenseEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}
