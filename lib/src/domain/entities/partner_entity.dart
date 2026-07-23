/// Tenant (partner) the logged-in user belongs to, with its branding.
///
/// `null` partner means a platform-level (system) user.
class PartnerEntity {
  PartnerEntity({
    required this.id,
    required this.brandName,
    this.primaryColor,
    this.logoUrl,
  });

  final int id;
  final String brandName;

  /// Tenant brand colour as a hex string (e.g. `#1A73E8`).
  ///
  /// WHY nullable: absence is meaningful — the app falls back to its default
  /// theme colour rather than inventing one.
  final String? primaryColor;

  /// Tenant logo; null when the partner has not uploaded one.
  final String? logoUrl;
}
