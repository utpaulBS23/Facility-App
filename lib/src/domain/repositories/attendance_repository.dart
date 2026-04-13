import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/attendance_entity.dart';

abstract base class AttendanceRepository extends Repository {
  Future<Result<AttendanceSummaryEntity, Failure>> getAttendanceSummary();
  Future<Result<AttendanceDetailEntity, Failure>> getAttendanceDetail(
    String id,
  );
}
