/// Tenant (partner) the logged-in user belongs to.
///
/// `null` partner means a platform-level (system) user.
class PartnerEntity {
  PartnerEntity({required this.id, this.name});

  final int id;
  final String? name;
}
