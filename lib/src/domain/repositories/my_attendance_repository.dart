import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/my_attendance_entity.dart';
import '../entities/supervisor_attendance_detail_entity.dart';

abstract base class MyAttendanceRepository extends Repository {
  Future<Result<MyAttendanceOverviewEntity, Failure>> getMyAttendance({
    required int partnerId,
    required String fromDay,
    required String toDay,
    int? facilityId,
    int? userId,
    int? page,
    int? perPage,
  });

  Future<Result<SupervisorAttendanceDetailEntity, Failure>>
  getSupervisorAttendanceDetails({
    required int partnerId,
    required int userId,
    required String date,
  });
}
