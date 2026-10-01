import '../../core/utils/localized_text.dart';

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
    this.nameBn,
  });

  final int id;
  final String? uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? userRole;
  final bool isActive;
  final String? profileImageUrl;
  final String? nameBn;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
