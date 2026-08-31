import '../models/my_attendance_model.dart';
import '../../domain/entities/my_attendance_entity.dart';
import 'date_time_parser.dart';

extension MyAttendanceStatsModelToEntity on MyAttendanceStatsModel {
  MyAttendanceStatsEntity toEntity() => MyAttendanceStatsEntity(
    records: records ?? 0,
    supervisors: supervisors ?? 0,
    stillOnRound: stillOnRound ?? 0,
    daysCovered: daysCovered ?? 0,
  );
}

extension MyAttendanceItemModelToEntity on MyAttendanceItemModel {
  MyAttendanceItemEntity toEntity() => MyAttendanceItemEntity(
    userId: userId,
    supervisorName: supervisorName ?? '',
    facilityId: facilityId,
    facilityName: facilityName ?? '',
    date: date ?? '',
    checkInAt: parseLocalIso(checkInAt),
    checkOutAt: parseLocalIso(checkOutAt),
    visitCount: visitCount ?? 0,
    hours: hours,
  );
}
