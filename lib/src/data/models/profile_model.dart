import 'package:dart_mappable/dart_mappable.dart';

part 'profile_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ProfilePartnerModel with ProfilePartnerModelMappable {
  ProfilePartnerModel({
    required this.id,
    this.name,
    this.brandName,
  });

  final int id;
  final String? name;
  @MappableField(key: 'brand_name')
  final String? brandName;

  static const fromJson = ProfilePartnerModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
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
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  @MappableField(key: 'user_type')
  final String? userType;
  final ProfilePartnerModel? partner;
  @MappableField(key: 'profile_image_url')
  final String? profileImageUrl;
  @MappableField(key: 'is_active')
  final bool? isActive;

  static const fromJson = UserProfileModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.encode)
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
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  @MappableField(key: 'current_password')
  final String? currentPassword;
  @MappableField(key: 'new_password')
  final String? newPassword;
  @MappableField(key: 'new_password_confirmation')
  final String? newPasswordConfirmation;
}
