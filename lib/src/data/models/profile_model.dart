import 'package:dart_mappable/dart_mappable.dart';

part 'profile_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ProfilePartnerModel with ProfilePartnerModelMappable {
  ProfilePartnerModel({
    required this.id,
    this.name,
    this.brandName,
  });

  final int id;
  final String? name;
  final String? brandName;

  static const fromJson = ProfilePartnerModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class UserProfileModel with UserProfileModelMappable {
  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.userType,
    this.partner,
    this.profileImageUrl,
    this.isActive,
  });

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? userType;
  final ProfilePartnerModel? partner;
  final String? profileImageUrl;
  final bool? isActive;

  static const fromJson = UserProfileModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode,
)
class UpdateProfileRequestModel with UpdateProfileRequestModelMappable {
  UpdateProfileRequestModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.currentPassword,
    this.newPassword,
    this.newPasswordConfirmation,
  });

  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? currentPassword;
  final String? newPassword;
  final String? newPasswordConfirmation;
}
