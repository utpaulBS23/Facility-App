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
    this.trackingSettings,
  });

  final Set<UserPermission> permissions;
  final List<AccessibleFacilityEntity> accessibleFacilities;
  final PartnerEntity? partner;
  final TrackingSettingsEntity? trackingSettings;

  // WHY: active partner is the single tenant scope every partner-scoped feature
  // reads. Today it is derived from the sole login-bound partner (one partner
  // per login); a future in-app partner switcher rebinds only this source — the
  // ~15 consumers stay untouched. Single derivation point, like [isShiftAttendant].
  final int? activePartnerId;

  bool get hasActivePartner => activePartnerId != null;

  bool can(UserPermission permission) => permissions.contains(permission);

  bool canAny(Iterable<UserPermission> candidates) => candidates.any((element) {
    return permissions.contains(element);
  });

  /// Which shift endpoint this session may read.
  ///
  /// WHY: each entitlement is chosen by the permission that is its *purpose* —
  /// managing a roster needs `shift.assign_attendant`, working a shift needs
  /// `attendance.check_in`. Deriving "supervisor" from the *absence* of
  /// check-in (the old `!isShiftAttendant`) defined authority as a gap, so a
  /// user with neither permission silently fell into the supervisor branch and
  /// fired a request they could not be authorised for.
  ///
  /// Manage wins when a session holds both (e.g. a slot lead). Revisit if
  /// leads need their own check-in flow — that becomes a UI affordance, not a
  /// change to this rule.
  // WHY: written long-hand, not with dot shorthand — the analyzer bundled with
  // the code generators cannot parse `.supervisor` here and fails the whole
  // build_runner run ("requires the 'dot-shorthands' language feature").
  ShiftEntitlement get shiftEntitlement {
    if (can(UserPermission.shiftAssignAttendant)) {
      return ShiftEntitlement.supervisor;
    }

    if (can(UserPermission.attendanceCheckIn)) {
      return ShiftEntitlement.attendant;
    }

    return ShiftEntitlement.none;
  }

  /// Whether the shift feature can serve this session at all.
  ///
  /// WHY: presentation only ever needs this yes/no — which of the two
  /// entitlements a session holds decides an *endpoint*, not a widget. Exposing
  /// the predicate keeps callers from re-deriving it by comparing against
  /// [ShiftEntitlement.none], which is how the enum previously leaked into
  /// authorization decisions it was never meant to answer.
  bool get hasShiftAccess => shiftEntitlement != ShiftEntitlement.none;
}

/// Which of the two shift endpoints a session is entitled to read.
///
/// WHY: named for the API it selects (`/attendants/my-shifts` vs
/// `/supervisors/manage-shifts`), not for a screen. It was `ShiftViewMode`,
/// which framed a data-access decision as a UI variant and invited callers to
/// treat it as a role — the thing this app deliberately does not have. Gate
/// *actions* on the permission that governs them; use this only to choose an
/// endpoint, or [UserSessionEntity.hasShiftAccess] to ask if the feature
/// applies at all.
enum ShiftEntitlement { attendant, supervisor, none }

/// Backend-driven cadence for background location pings.
///
/// WHY: interval is server-configurable, not hardcoded — ops can retune
/// battery/accuracy tradeoffs per partner without an app release.
class TrackingSettingsEntity {
  TrackingSettingsEntity({
    this.idlePingIntervalSeconds,
    this.activeVisitPingIntervalSeconds,
    this.trackingMode,
  });

  final int? idlePingIntervalSeconds;
  final int? activeVisitPingIntervalSeconds;
  final String? trackingMode;
}

interface class LoginEntity {}

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
    this.profileImage,
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
  final String? profileImage;
}

class LoginRequestEntity extends LoginEntity {
  LoginRequestEntity({
    required this.uid,
    required this.password,
    required this.deviceName,
    this.deviceId,
    this.deviceModel,
    this.osVersion,
  });

  final String uid;
  final String password;
  final String deviceName;
  final String? deviceId;
  final String? deviceModel;
  final String? osVersion;
}

class LoginResponseEntity extends LoginEntity {
  LoginResponseEntity({
    required this.user,
    required this.accessToken,
    required this.permissions,
    required this.accessibleFacilities,
    this.partner,
    this.trackingSettings,
  });

  final UserEntity user;
  final String accessToken;
  final Set<UserPermission> permissions;
  final List<AccessibleFacilityEntity> accessibleFacilities;
  final PartnerEntity? partner;
  final TrackingSettingsEntity? trackingSettings;
}
