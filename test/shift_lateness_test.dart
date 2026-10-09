import 'package:facility_management_app/src/core/utils/shift_lateness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dhaka wall clock', () {
    test('is UTC+6 whatever the phone zone is', () {
      final wall = dhakaWallClock(DateTime.utc(2026, 10, 7, 20, 30));

      expect(wall, DateTime.utc(2026, 10, 8, 2, 30));
    });

    test('a shift time reads as a Dhaka wall clock', () {
      expect(
        shiftMoment('2026-10-07', '06:00:00'),
        DateTime.utc(2026, 10, 7, 6),
      );
      expect(shiftMoment('2026-10-07', '06:00'), DateTime.utc(2026, 10, 7, 6));
      expect(shiftMoment('bad', '06:00'), isNull);
      expect(shiftMoment('2026-10-07', ''), isNull);
    });
  });

  group('late check-in', () {
    final deadline = checkInDeadline(
      date: '2026-10-07',
      startTime: '06:00:00',
      graceMinutes: 30,
    );

    test('the on-time window ends at start plus the grace period', () {
      expect(deadline, DateTime.utc(2026, 10, 7, 6, 30));
    });

    test('at the deadline it is still on time, a minute later it is late', () {
      expect(isPast(deadline, DateTime.utc(2026, 10, 7, 6, 30)), isFalse);
      expect(isPast(deadline, DateTime.utc(2026, 10, 7, 6, 31)), isTrue);
    });

    test('an early check-in is on time', () {
      expect(isPast(deadline, DateTime.utc(2026, 10, 7, 5, 50)), isFalse);
    });

    test('an unknown deadline claims nothing', () {
      expect(isPast(null, DateTime.utc(2030)), isFalse);
    });
  });

  group('late check-out', () {
    final deadline = checkOutDeadline(
      date: '2026-10-07',
      endTime: '14:00:00',
      graceMinutes: 60,
    );

    test('the on-time window ends at end plus the grace period', () {
      expect(deadline, DateTime.utc(2026, 10, 7, 15));
    });

    test('a picked check-out time is judged, not the current time', () {
      expect(isPast(deadline, DateTime.utc(2026, 10, 7, 14, 40)), isFalse);
      expect(isPast(deadline, DateTime.utc(2026, 10, 7, 15, 5)), isTrue);
    });
  });

  group('early check-out', () {
    final opens = checkOutOpens(date: '2026-10-07', endTime: '14:00:00');

    test('check-out opens when the shift ends', () {
      expect(opens, DateTime.utc(2026, 10, 7, 14));
    });

    test('before the end is early, from the end on it is not', () {
      expect(isBefore(opens, DateTime.utc(2026, 10, 7, 13, 59)), isTrue);
      expect(isBefore(opens, DateTime.utc(2026, 10, 7, 14)), isFalse);
      expect(isBefore(opens, DateTime.utc(2026, 10, 7, 14, 20)), isFalse);
    });

    test('an unknown end claims nothing', () {
      expect(isBefore(null, DateTime.utc(2020)), isFalse);
    });
  });

  test('a wall clock is written as HH:mm', () {
    expect(wallClockHm(DateTime.utc(2026, 10, 7, 6, 5)), '06:05');
  });
}
