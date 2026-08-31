import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/my_attendance_entity.dart';

abstract base class MyAttendanceRepository extends Repository {
  Future<Result<MyAttendanceOverviewEntity, Failure>> getMyAttendance({
    required int partnerId,
    required String fromDay,
    required String toDay,
    int? facilityId,
    int? userId,
  });
}
