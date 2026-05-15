import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/attendance_entity.dart';

abstract base class AttendanceRepository extends Repository {
  Future<Result<MonthlyAttendanceSummaryEntity, Failure>> getMonthlyAttendanceOverview({
    required int partnerId,
    required String month,
  });

  Future<Result<AttendanceItemEntity, Failure>> approveAttendance({
    required int partnerId,
    required int attendanceId,
  });

  Future<Result<AttendanceItemEntity, Failure>> rejectAttendance({
    required int partnerId,
    required int attendanceId,
  });
}
