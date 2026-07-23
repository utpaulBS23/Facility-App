/// A facility the logged-in user may operate in, as sent by login under
/// `accessible_facilities`.
///
/// An empty list means the user has no facility access — it does NOT mean
/// "all facilities".
class AccessibleFacilityEntity {
  const AccessibleFacilityEntity({
    required this.id,
    required this.name,
    required this.isPrimary,
  });

  final int id;
  final String name;

  /// The user's home/default facility. At most one is expected to be primary.
  final bool isPrimary;
}
