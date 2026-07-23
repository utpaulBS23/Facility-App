/// A partner's staff member, listed as a candidate when assigning someone to
/// a shift slot.
class PartnerStaffEntity {
  const PartnerStaffEntity({
    required this.id,
    this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.userRole,
    required this.isActive,
    this.profileImageUrl,
  });

  final int id;
  final String? uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? userRole;
  final bool isActive;
  final String? profileImageUrl;
}
