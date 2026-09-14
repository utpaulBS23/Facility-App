import 'travel_expense_status.dart';

/// Which table [CreateTravelExpenseRequestEntity.startId] refers to when
/// [CreateTravelExpenseRequestEntity.taskId] is not given.
enum TravelExpenseStartType { facility, home, office }

/// Filter query parameters for the travel-expense list
/// (`GET /travel-expenses`).
class TravelExpenseFilter {
  const TravelExpenseFilter({
    this.partnerId,
    this.status,
    this.facilityId,
  });

  final int? partnerId;
  final TravelExpenseStatus? status;
  final int? facilityId;

  TravelExpenseFilter copyWith({
    int? partnerId,
    TravelExpenseStatus? status,
    int? facilityId,
  }) {
    return TravelExpenseFilter(
      partnerId: partnerId ?? this.partnerId,
      status: status ?? this.status,
      facilityId: facilityId ?? this.facilityId,
    );
  }
}

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
    this.partnerId,
    this.taskId,
    this.facilityId,
    this.startType,
    this.startId,
    this.purpose,
    this.amount,
    required this.legs,
  });

  /// Domain-only — attached by [CreateTravelExpenseUseCase] via [copyWith],
  /// used solely to address the `POST` path. Never serialized into the
  /// request body.
  final int? partnerId;

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

  CreateTravelExpenseRequestEntity copyWith({
    int? partnerId,
    int? taskId,
    int? facilityId,
    TravelExpenseStartType? startType,
    int? startId,
    String? purpose,
    double? amount,
    List<TravelExpenseLegEntity>? legs,
  }) {
    return CreateTravelExpenseRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      taskId: taskId ?? this.taskId,
      facilityId: facilityId ?? this.facilityId,
      startType: startType ?? this.startType,
      startId: startId ?? this.startId,
      purpose: purpose ?? this.purpose,
      amount: amount ?? this.amount,
      legs: legs ?? this.legs,
    );
  }
}

/// One itemized transport line as recorded by the backend — only the label
/// is rendered (joined into the list card's "Rickshaw + Bus" mode text).
class TravelExpenseLineEntity {
  const TravelExpenseLineEntity({
    required this.id,
    required this.vehicleTypeLabel,
  });

  final int id;
  final String vehicleTypeLabel;
}

/// The claim as recorded by the backend after submission — trimmed to just
/// the fields the list/create-confirmation UI renders.
class TravelExpenseEntity {
  const TravelExpenseEntity({
    required this.id,
    required this.facilityName,
    required this.userName,
    required this.purpose,
    required this.claimedDistanceKm,
    required this.claimedAmount,
    required this.status,
    required this.submittedAt,
    required this.rejectionNote,
    required this.transportLines,
  });

  final int id;
  final String facilityName;
  final String userName;
  final String purpose;

  /// Summed from the submitted legs against the partner's rate — or the
  /// client-supplied [CreateTravelExpenseRequestEntity.amount] override.
  final double claimedDistanceKm;
  final double claimedAmount;

  /// Review (approve/reject/adjust) happens outside this app; this only
  /// reflects the state as last fetched.
  final TravelExpenseStatus status;
  final String submittedAt;
  final String rejectionNote;
  final List<TravelExpenseLineEntity> transportLines;
}
