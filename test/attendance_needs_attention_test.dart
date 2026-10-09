import 'package:facility_management_app/src/domain/entities/attendance/attendance_approval_status.dart';
import 'package:facility_management_app/src/domain/entities/attendance_entity.dart';
import 'package:flutter_test/flutter_test.dart';

AttendanceItemEntity _entry(String status, {DateTime? checkOut}) =>
    AttendanceItemEntity(
      userId: 1,
      userName: 'Rahim',
      userUid: 'U1',
      date: '2020-01-01',
      status: status,
      isLate: false,
      checkInTime: DateTime(2020, 1, 1, 8),
      checkOutTime: checkOut,
      attendanceType: 'app',
      approvalStatus: AttendanceApprovalStatus.fromWireString(status),
    );

void main() {
  test('an open check-in from an earlier day needs attention', () {
    expect(_entry('approved').needsAttention, isTrue);
  });

  test('a rejected check-in is settled and needs no attention', () {
    expect(_entry('rejected_check_in').needsAttention, isFalse);
    expect(_entry('rejected').needsAttention, isFalse);
  });

  test('a checked-out entry needs no attention', () {
    expect(
      _entry('approved', checkOut: DateTime(2020, 1, 1, 16)).needsAttention,
      isFalse,
    );
  });
}
