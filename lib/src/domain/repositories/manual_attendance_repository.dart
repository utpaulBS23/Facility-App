import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/manual_attendance_entity.dart';

abstract base class ManualAttendanceRepository extends Repository {
  Future<Result<ManualAttendanceResponseEntity, Failure>> submitManualAttendance({
    required int partnerId,
    required ManualAttendanceRequestEntity request,
  });
}
