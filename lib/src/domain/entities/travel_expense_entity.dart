/// Which table [CreateTravelExpenseRequestEntity.startId] refers to when
/// [CreateTravelExpenseRequestEntity.taskId] is not given.
enum TravelExpenseStartType { facility, home, office }

/// One transport leg of a travel-expense claim (e.g. rickshaw for 5km, then
/// bus for 48km).
///
/// WHY [vehicleTypeItemId] not an enum: the transport mode list is
/// server-configured master data (`GET .../master-data/items?category=
/// transportMode`), not a fixed client-side set — see
/// `claimExpenseTransportModesProvider`.
///
/// WHY no rate/amount here: `claimed_amount` is computed server-side from
/// the partner's currently configured rate — the client only ever supplies
/// distance, never a rate.
class TravelExpenseLegEntity {
  const TravelExpenseLegEntity({
    required this.vehicleTypeItemId,
    required this.distanceKm,
  });

  final int vehicleTypeItemId;
  final double distanceKm;
}

/// A travel-expense claim submitted for supervisor approval.
///
/// WHY no supervisorId: this is always the caller's own claim — the backend
/// identifies the approving supervisor from the authenticated session, not
/// a value the claimant picks.
///
/// WHY facilityId/startType/startId are all nullable: when [taskId] is set,
/// the backend derives all three from that task's recorded travel origin —
/// sending them anyway is either ignored or (for facilityId) cross-checked
/// and rejected on mismatch, so this app omits them whenever taskId is
/// present. Without a taskId they're required — enforced by the page before
/// building this request, not by this entity.
class CreateTravelExpenseRequestEntity {
  const CreateTravelExpenseRequestEntity({
    this.taskId,
    this.facilityId,
    this.startType,
    this.startId,
    this.purpose,
    this.amount,
    required this.legs,
  });

  /// The completed visit this claim is for, when tied to one.
  final int? taskId;

  /// The visited facility. Required, and used as-is, only when [taskId] is
  /// null.
  final int? facilityId;

  /// Required, and used as-is, only when [taskId] is null.
  final TravelExpenseStartType? startType;

  /// Required, and used as-is, only when [taskId] is null. For
  /// [TravelExpenseStartType.home] this must be the caller's own user id.
  final int? startId;

  final String? purpose;

  /// Client-supplied override of the server-computed claimed amount.
  final double? amount;

  final List<TravelExpenseLegEntity> legs;

  double get totalDistanceKm =>
      legs.fold(0, (sum, leg) => sum + leg.distanceKm);
}

/// One itemized transport line as recorded by the backend.
class TravelExpenseLineEntity {
  const TravelExpenseLineEntity({
    required this.id,
    required this.vehicleTypeItemId,
    this.vehicleTypeLabel,
    required this.distanceKm,
    required this.amount,
  });

  final int id;
  final int vehicleTypeItemId;
  final String? vehicleTypeLabel;
  final double distanceKm;
  final double amount;
}

/// The claim as recorded by the backend after submission.
class TravelExpenseEntity {
  const TravelExpenseEntity({
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
    required this.status,
    this.transportLines = const [],
  });

  final int id;
  final int? taskId;
  final int? facilityId;
  final String? facilityName;
  final String? purpose;

  /// Freshly re-resolved via the routing provider (Barikoi) at submit time.
  final double? calculatedDistanceKm;
  final double? calculatedAmount;

  /// Summed from the submitted legs against the partner's rate — or the
  /// client-supplied [CreateTravelExpenseRequestEntity.amount] override.
  final double? claimedDistanceKm;
  final double? claimedAmount;
  final double? ratePerKm;

  /// e.g. "waiting" — review (approve/reject/adjust) happens outside this
  /// app; this only reflects the state at submission time.
  final String status;
  final List<TravelExpenseLineEntity> transportLines;
}
