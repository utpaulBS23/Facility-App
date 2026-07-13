import 'app_permission.dart';
import 'partner_entity.dart';

export 'app_permission.dart';
export 'partner_entity.dart';

class UserSessionEntity {
  UserSessionEntity({
    required this.permissions,
    required this.accessibleFacilities,
    this.partner,
  });

  final Set<AppPermission> permissions;
  final List<String> accessibleFacilities;
  final PartnerEntity? partner;

  bool can(AppPermission permission) => permissions.contains(permission);

  bool canAny(Iterable<AppPermission> candidates) =>
      candidates.any(permissions.contains);

  // WHY: backend dropped user_role entirely — the attendant experience is
  // now defined by capability: whoever can check in to a shift gets the
  // attendant UI variant; everyone else gets the supervisor/manager variant.
  // Single derivation point — swap this expression if the backend later
  // ships an explicit capability or role key.
  bool get isShiftAttendant => can(AppPermission.attendanceCheckIn);
}

interface class LoginEntity {}

enum ShiftStatusFlag {
  shiftScheduledToday,
  alreadyCheckedIn,
  noShiftToday,
  shiftNotYetAccessible,
  shiftWindowClosed;

  static ShiftStatusFlag fromString(String value) => switch (value) {
    'SHIFT_SCHEDULED_TODAY' => ShiftStatusFlag.shiftScheduledToday,
    'ALREADY_CHECKED_IN' => ShiftStatusFlag.alreadyCheckedIn,
    'NO_SHIFT_TODAY' => ShiftStatusFlag.noShiftToday,
    'SHIFT_NOT_YET_ACCESSIBLE' => ShiftStatusFlag.shiftNotYetAccessible,
    'SHIFT_WINDOW_CLOSED' => ShiftStatusFlag.shiftWindowClosed,
    _ => ShiftStatusFlag.noShiftToday,
  };
}

class ShiftStatusEntity {
  ShiftStatusEntity({
    required this.flag,
    required this.message,
    this.shiftId,
    this.facilityName,
    this.startTime,
    this.endTime,
  });

  final ShiftStatusFlag flag;
  final String message;
  final int? shiftId;
  final String? facilityName;
  final String? startTime;
  final String? endTime;
}

class UserEntity extends LoginEntity {
  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
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
  final int? partnerId;
  final String? supervisor;
  final int permissionVersion;
  final bool twoFactorEnabled;
}

class LoginRequestEntity extends LoginEntity {
  LoginRequestEntity({
    required this.uid,
    required this.password,
    required this.deviceName,
  });

  final String uid;
  final String password;
  final String deviceName;
}

class LoginResponseEntity extends LoginEntity {
  LoginResponseEntity({
    required this.user,
    required this.accessToken,
    required this.permissions,
    required this.accessibleFacilities,
    this.partner,
    this.shiftStatus,
  });

  final UserEntity user;
  final String accessToken;
  final Set<AppPermission> permissions;
  final List<String> accessibleFacilities;
  final PartnerEntity? partner;
  final ShiftStatusEntity? shiftStatus;
}
