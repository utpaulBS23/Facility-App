import 'user_role.dart';

export 'user_role.dart';

class UserSessionEntity {
  UserSessionEntity({
    required this.role,
    required this.permissions,
    required this.accessibleFacilities,
  });

  final UserRole role;
  final List<String> permissions;
  final List<String> accessibleFacilities;
}

interface class LoginEntity {}

enum ShiftStatusFlag {
  shiftScheduledToday,
  alreadyCheckedIn,
  noShiftToday;

  static ShiftStatusFlag fromString(String value) => switch (value) {
    'SHIFT_SCHEDULED_TODAY' => ShiftStatusFlag.shiftScheduledToday,
    'ALREADY_CHECKED_IN' => ShiftStatusFlag.alreadyCheckedIn,
    _ => ShiftStatusFlag.noShiftToday,
  };
}

class ShiftStatusEntity {
  ShiftStatusEntity({required this.flag, required this.message});

  final ShiftStatusFlag flag;
  final String message;
}

class UserEntity extends LoginEntity {
  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.userRole,
    this.partnerId,
    this.supervisor,
    required this.permissionVersion,
    required this.twoFactorEnabled,
  });

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String userType;
  final UserRole? userRole;
  final int? partnerId;
  final String? supervisor;
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
    this.shiftStatus,
  });

  final UserEntity user;
  final String accessToken;
  final List<String> permissions;
  final List<String> accessibleFacilities;
  final ShiftStatusEntity? shiftStatus;
}
