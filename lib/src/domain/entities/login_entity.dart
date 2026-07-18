import 'accessible_facility_entity.dart';
import 'app_permission.dart';
import 'partner_entity.dart';

export 'accessible_facility_entity.dart';
export 'app_permission.dart';
export 'partner_entity.dart';

class UserSessionEntity {
  UserSessionEntity({
    required this.permissions,
    required this.accessibleFacilities,
    this.partner,
    this.activePartnerId,
  });

  final Set<AppPermission> permissions;
  final List<AccessibleFacilityEntity> accessibleFacilities;
  final PartnerEntity? partner;

  // WHY: active partner is the single tenant scope every partner-scoped feature
  // reads. Today it is derived from the sole login-bound partner (one partner
  // per login); a future in-app partner switcher rebinds only this source — the
  // ~15 consumers stay untouched. Single derivation point, like [isShiftAttendant].
  final int? activePartnerId;

  bool get hasActivePartner => activePartnerId != null;

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
  final List<AccessibleFacilityEntity> accessibleFacilities;
  final PartnerEntity? partner;
  final ShiftStatusEntity? shiftStatus;
}
