import '../../domain/entities/travel_expense_entity.dart';
import '../../domain/entities/travel_expense_status.dart';
import '../models/travel_expense_model.dart';

extension TravelExpenseLegEntityToModel on TravelExpenseLegEntity {
  TravelExpenseLegRequestModel toModel() => TravelExpenseLegRequestModel(
    vehicleTypeItemId: vehicleTypeItemId,
    distanceKm: distanceKm,
    amount: amount,
  );
}

extension _TravelExpenseStartTypeToWire on TravelExpenseStartType {
  String get wireValue => switch (this) {
    TravelExpenseStartType.facility => 'facility',
    TravelExpenseStartType.home => 'home',
    TravelExpenseStartType.office => 'office',
  };
}

extension _TravelExpenseStartTypeFromWire on String? {
  TravelExpenseStartType? get toStartType => switch (this) {
    'facility' => TravelExpenseStartType.facility,
    'home' => TravelExpenseStartType.home,
    'office' => TravelExpenseStartType.office,
    _ => null,
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
    distanceKm: distanceKm,
    claimedAmount: claimedAmount ?? amount,
  );
}

extension TravelExpenseModelToEntity on TravelExpenseModel {
  TravelExpenseEntity toEntity() => TravelExpenseEntity(
    id: id,
    facilityName: facilityName ?? '',
    facilityNameBn: facilityNameBn ?? '',
    officeId: officeId,
    officeName: officeName,
    officeNameBn: officeNameBn ?? '',
    userId: userId,
    startType: startType.toStartType,
    startId: startId,
    userName: userName ?? '',
    userNameBn: userNameBn ?? '',
    purpose: purpose ?? '',
    claimedDistanceKm: claimedDistanceKm ?? 0,
    claimedAmount: claimedAmount ?? 0,
    status: TravelExpenseStatus.fromWireString(status),
    submittedAt: submittedAt ?? '',
    rejectionNote: rejectionNote ?? '',
    approvedAmount: approvedAmount,
    adjustmentReason: adjustmentReason,
    transportLines:
        transportLines?.map((line) => line.toEntity()).toList() ?? const [],
  );
}

extension TravelExpenseListResponseModelToEntity
    on TravelExpenseListResponseModel {
  List<TravelExpenseEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}
