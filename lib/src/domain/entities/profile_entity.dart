import '../../core/utils/localized_text.dart';

class UserProfileEntity {
  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.partnerName,
    required this.profileImageUrl,
    this.partnerNameBn = '',
    this.nameBn = '',
  });

  final int id;
  final String name;
  final String nameBn;
  final String email;
  final String phoneNumber;
  final String userType;
  final String partnerName;
  final String partnerNameBn;
  final String profileImageUrl;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);

  String localizedPartnerName(String languageCode) =>
      localizedText(languageCode, partnerName, partnerNameBn);
}
