/// A transport mode selectable on a travel-expense leg, each with its own
/// per-km rate.
enum TransportMode {
  rickshaw('rickshaw'),
  bus('bus'),
  cng('cng'),
  bike('bike'),
  car('car'),
  boat('boat'),
  walking('walking'),
  other('other');

  const TransportMode(this.key);

  final String key;

  // WHY a client-side default table, not a backend config call: no such
  // endpoint exists yet. The web mock labels this "Auto-suggested ... —
  // editable" — these are starting points the user can always override
  // before submitting, not authoritative pricing.
  double get suggestedRatePerKm => switch (this) {
    TransportMode.rickshaw => 12,
    TransportMode.bus => 4,
    TransportMode.cng => 15,
    TransportMode.bike => 8,
    TransportMode.car => 20,
    TransportMode.boat => 10,
    TransportMode.walking => 0,
    TransportMode.other => 0,
  };

  static TransportMode fromKey(String? key) => switch (key) {
    'rickshaw' => TransportMode.rickshaw,
    'bus' => TransportMode.bus,
    'cng' => TransportMode.cng,
    'bike' => TransportMode.bike,
    'car' => TransportMode.car,
    'boat' => TransportMode.boat,
    'walking' => TransportMode.walking,
    _ => TransportMode.other,
  };
}

/// One transport leg of a travel-expense claim (e.g. rickshaw for 5km, then
/// bus for 48km).
class TravelExpenseLegEntity {
  const TravelExpenseLegEntity({
    required this.mode,
    required this.distanceKm,
    required this.ratePerKm,
  });

  final TransportMode mode;
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
