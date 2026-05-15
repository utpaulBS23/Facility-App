import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/manual_attendance_entity.dart';

abstract base class ManualAttendanceRepository extends Repository {
  Future<Result<ManualAttendanceResponseEntity, Failure>> submitManualAttendance({
    required int partnerId,
    required ManualAttendanceRequestEntity request,
  });

  Future<Result<ManualAttendanceResponseEntity, Failure>> refreshAttendance({
    required int partnerId,
    required int shiftId,
  });

  Future<Result<bool, Failure>> withdrawAttendance({
    required int partnerId,
    required int attendanceId,
  });
}
