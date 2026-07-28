import 'package:flutter_test/flutter_test.dart';

import 'package:facility_management_app/src/domain/entities/login_entity.dart';

UserSessionEntity _session(Set<AppPermission> permissions) =>
    UserSessionEntity(permissions: permissions, accessibleFacilities: const []);

/// Pins the single point where a session's shift entitlement is derived.
///
/// The rule this protects: entitlement is chosen by the permission that is the
/// *purpose* of each experience, never by the absence of another one. The
/// earlier `isShiftAttendant`/`!isShiftAttendant` form defined supervisor as a
/// gap, so a session holding neither permission fell into the supervisor branch
/// and fired a request it could not be authorised for.
void main() {
  group('shiftEntitlement', () {
    test('assign_attendant selects the supervisor endpoint', () {
      final session = _session({AppPermission.shiftAssignAttendant});

      expect(session.shiftEntitlement, ShiftEntitlement.supervisor);
      expect(session.hasShiftAccess, isTrue);
    });

    test('check_in selects the attendant endpoint', () {
      final session = _session({AppPermission.attendanceCheckIn});

      expect(session.shiftEntitlement, ShiftEntitlement.attendant);
      expect(session.hasShiftAccess, isTrue);
    });

    test('managing wins when a session holds both (e.g. a slot lead)', () {
      final session = _session({
        AppPermission.shiftAssignAttendant,
        AppPermission.attendanceCheckIn,
      });

      expect(session.shiftEntitlement, ShiftEntitlement.supervisor);
    });

    test('holding neither fails closed rather than defaulting', () {
      final session = _session(const {});

      expect(session.shiftEntitlement, ShiftEntitlement.none);
      expect(
        session.hasShiftAccess,
        isFalse,
        reason: 'no permission must never fall through to supervisor',
      );
    });

    test('an unrelated permission grants no shift access', () {
      final session = _session({AppPermission.taskView});

      expect(session.shiftEntitlement, ShiftEntitlement.none);
      expect(session.hasShiftAccess, isFalse);
    });
  });

  group('permission predicates', () {
    final session = _session({
      AppPermission.taskView,
      AppPermission.attendanceApprove,
    });

    test('can() is exact, not prefix or substring', () {
      expect(session.can(AppPermission.taskView), isTrue);
      expect(session.can(AppPermission.taskComplete), isFalse);
    });

    test('canAny() is true when one candidate matches', () {
      expect(
        session.canAny(const [
          AppPermission.attendanceApprove,
          AppPermission.attendanceReject,
        ]),
        isTrue,
      );
    });

    test(
      'canAny() is false when none match, and on an empty candidate list',
      () {
        expect(session.canAny(const [AppPermission.rosterCreate]), isFalse);
        expect(session.canAny(const []), isFalse);
      },
    );
  });

  group('hasActivePartner', () {
    test('is false for a platform account (partner_id: null)', () {
      expect(_session(const {}).hasActivePartner, isFalse);
    });

    test('is true once a partner is bound', () {
      final session = UserSessionEntity(
        permissions: const {},
        accessibleFacilities: const [],
        activePartnerId: 6,
      );

      expect(session.hasActivePartner, isTrue);
    });
  });
}
