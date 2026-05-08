interface class LoginEntity {}

class UserEntity extends LoginEntity {
  UserEntity({
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
  final String? phoneNumber;
  final String userType;
  final int? partnerId;
  final int permissionVersion;
  final bool twoFactorEnabled;
}

class LoginRequestEntity extends LoginEntity {
  LoginRequestEntity({
    required this.email,
    required this.password,
    required this.deviceName,
  });

  final String email;
  final String password;
  final String deviceName;
}

class LoginResponseEntity extends LoginEntity {
  LoginResponseEntity({
    required this.user,
    required this.accessToken,
    required this.permissions,
    required this.accessibleFacilities,
  });

  final UserEntity user;
  final String accessToken;
  final List<String> permissions;
  final List<String> accessibleFacilities;
}
