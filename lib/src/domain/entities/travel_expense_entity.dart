/// One transport leg of a travel-expense claim (e.g. rickshaw for 5km, then
/// bus for 48km).
///
/// WHY [vehicleTypeItemId] not an enum: the transport mode list is
/// server-configured master data (`GET .../master-data/items?category=
/// transportMode`), not a fixed client-side set — see
/// `claimExpenseTransportModesProvider`.
class TravelExpenseLegEntity {
  const TravelExpenseLegEntity({
    required this.vehicleTypeItemId,
    required this.distanceKm,
    required this.ratePerKm,
  });

  final int vehicleTypeItemId;
  final double distanceKm;
  final double ratePerKm;

  double get amount => distanceKm * ratePerKm;
}

/// A travel-expense claim submitted for supervisor approval.
///
/// WHY no supervisorId: this is always the caller's own claim — the backend
/// identifies the approving supervisor from the authenticated session, not
/// a value the claimant picks.
class CreateTravelExpenseRequestEntity {
  const CreateTravelExpenseRequestEntity({
    required this.facilityId,
    this.visitId,
    required this.startLocation,
    required this.destination,
    required this.legs,
    required this.purpose,
  });

  final int facilityId;

  /// The visit this journey was made for, when the claim is tied to one.
  final int? visitId;

  final String startLocation;
  final String destination;
  final List<TravelExpenseLegEntity> legs;
  final String purpose;

  double get totalDistanceKm =>
      legs.fold(0, (sum, leg) => sum + leg.distanceKm);

  double get totalAmount => legs.fold(0, (sum, leg) => sum + leg.amount);
}

/// The claim as recorded by the backend after submission.
class TravelExpenseEntity {
  const TravelExpenseEntity({
    required this.id,
    required this.totalDistanceKm,
    required this.totalAmount,
    required this.status,
  });

  final int id;
  final double totalDistanceKm;
  final double totalAmount;
  final String status;
}
