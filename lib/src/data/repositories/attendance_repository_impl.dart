import '../../core/base/base.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';

final class AttendanceRepositoryImpl extends AttendanceRepository {
  // WHY: Dummy data simulates what the real API would return.
  static final List<AttendanceRecordEntity> _dummyRecords = [
    const AttendanceRecordEntity(
      id: '1',
      dateLabel: 'Today',
      isToday: true,
      status: AttendanceStatus.present,
      checkInTime: '8:02 AM',
    ),
    const AttendanceRecordEntity(
      id: '2',
      dateLabel: 'Sun, Feb 8',
      isToday: false,
      status: AttendanceStatus.present,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      hoursWorked: '8h 07m',
    ),
    const AttendanceRecordEntity(
      id: '3',
      dateLabel: 'Sat, Feb 7',
      isToday: false,
      status: AttendanceStatus.late,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      hoursWorked: '7h 35m',
    ),
    const AttendanceRecordEntity(
      id: '4',
      dateLabel: 'Sat, Feb 7',
      isToday: false,
      status: AttendanceStatus.onLeave,
    ),
    const AttendanceRecordEntity(
      id: '5',
      dateLabel: 'Sun, Feb 8',
      isToday: false,
      status: AttendanceStatus.present,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      hoursWorked: '8h 07m',
    ),
  ];

  static final Map<String, AttendanceDetailEntity> _dummyDetails = {
    '1': const AttendanceDetailEntity(
      id: '1',
      dateLabel: 'Today',
      status: AttendanceStatus.present,
      checkInTime: '8:02 AM',
      location: 'Mirpur-10, Dhaka',
      shiftType: 'Morning',
      supervisorApproval: SupervisorApprovalEntity(
        name: 'Bob Johnson',
        phone: '+880 1911-234567',
        isCheckOut: true,
        reason: 'Camera is not working',
      ),
    ),
    '2': const AttendanceDetailEntity(
      id: '2',
      dateLabel: 'Sun, Feb 8',
      status: AttendanceStatus.present,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      location: 'Mirpur-10, Dhaka',
      hoursWorked: '8h 07m',
      shiftType: 'Afternoon',
    ),
    '3': const AttendanceDetailEntity(
      id: '3',
      dateLabel: 'Sat, Feb 7',
      status: AttendanceStatus.late,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      location: 'Mirpur-10, Dhaka',
      hoursWorked: '7h 35m',
      shiftType: 'Afternoon',
    ),
    '4': const AttendanceDetailEntity(
      id: '4',
      dateLabel: 'Sat, Feb 7',
      status: AttendanceStatus.onLeave,
      location: 'Mirpur-10, Dhaka',
      shiftType: 'Morning',
    ),
    '5': const AttendanceDetailEntity(
      id: '5',
      dateLabel: 'Sun, Feb 8',
      status: AttendanceStatus.present,
      checkInTime: '3:15 PM',
      checkOutTime: '4:05 PM',
      location: 'Mirpur-10, Dhaka',
      hoursWorked: '8h 07m',
      shiftType: 'Afternoon',
    ),
  };

  @override
  Future<Result<AttendanceSummaryEntity, Failure>> getAttendanceSummary() async {
    return asyncGuard(() async {
      return AttendanceSummaryEntity(
        presentCount: 4,
        lateCount: 4,
        absentCount: 4,
        leaveCount: 4,
        records: _dummyRecords,
      );
    });
  }

  @override
  Future<Result<AttendanceDetailEntity, Failure>> getAttendanceDetail(
    String id,
  ) async {
    return asyncGuard(() async {
      final detail = _dummyDetails[id];
      if (detail == null) throw Exception('Record not found');
      return detail;
    });
  }
}
