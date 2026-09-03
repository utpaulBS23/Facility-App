class UserProfileEntity {
  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.partnerName,
    required this.profileImageUrl,
  });

  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String userType;
  final String partnerName;
  final String profileImageUrl;
}
