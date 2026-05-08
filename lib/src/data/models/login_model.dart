import 'package:dart_mappable/dart_mappable.dart';

part 'login_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class UserModel with UserModelMappable {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.partnerId,
    required this.permissionVersion,
    required this.twoFactorEnabled,
  });

  final int id;
  final String name;
  final String email;
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  @MappableField(key: 'user_type')
  final String userType;
  @MappableField(key: 'partner_id')
  final int? partnerId;
  @MappableField(key: 'permission_version')
  final int permissionVersion;
  @MappableField(key: 'two_factor_enabled')
  final bool twoFactorEnabled;

  static const fromJson = UserModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LoginTokenModel with LoginTokenModelMappable {
  LoginTokenModel({required this.accessToken, required this.type});

  @MappableField(key: 'access_token')
  final String accessToken;
  final String type;

  static const fromJson = LoginTokenModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LoginResponseModel with LoginResponseModelMappable {
  LoginResponseModel({
    required this.user,
    required this.token,
    required this.permissions,
    required this.accessibleFacilities,
  });

  final UserModel user;
  final LoginTokenModel token;
  final List<String> permissions;
  @MappableField(key: 'accessible_facilities')
  final List<String> accessibleFacilities;

  static const fromJson = LoginResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class LoginRequestModel with LoginRequestModelMappable {
  LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceName,
  });

  final String email;
  final String password;
  @MappableField(key: 'device_name')
  final String deviceName;
}
