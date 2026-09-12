import '../models/attendance_model.dart';
import '../../domain/entities/attendance_entity.dart';
import 'date_time_parser.dart';

extension AttendanceApproverModelToEntity on AttendanceApproverModel {
  AttendanceApproverEntity toEntity() =>
      AttendanceApproverEntity(id: id, name: name ?? '', uid: uid);
}

extension AttendanceShiftInfoModelToEntity on AttendanceShiftInfoModel {
  AttendanceShiftInfoEntity toEntity() => AttendanceShiftInfoEntity(
    id: id,
    shiftType: shiftType ?? '',
    startTime: startTime ?? '',
    endTime: endTime ?? '',
    facilityName: facilityName ?? '',
  );
}

extension AttendanceItemModelToEntity on AttendanceItemModel {
  AttendanceItemEntity toEntity() => AttendanceItemEntity(
    id: id,
    userId: userId,
    userName: userName ?? '',
    userUid: userUid ?? '',
    date: date ?? '',
    status: status ?? 'pending',
    isLate: isLate ?? false,
    checkInTime: parseLocalIso(checkInTime),
    checkOutTime: parseLocalIso(checkOutTime),
    durationHours: durationHours?.toString(),
    attendanceType: attendanceType ?? 'app',
    location: location,
    reason: reason,
    checkInSelfie: checkInSelfie,
    checkOutSelfie: checkOutSelfie,
    shift: shift?.toEntity(),
    approver: approver?.toEntity(),
  );
}

extension AttendanceOverviewResponseModelToEntity
    on AttendanceOverviewResponseModel {
  MonthlyAttendanceSummaryEntity toEntity() {
    return MonthlyAttendanceSummaryEntity(
      presentCount: summary?.presentCount,
      lateCount: summary?.lateCount,
      absentCount: summary?.absentCount,
      rejectCount: summary?.rejectCount,
      leaveCount: summary?.leaveCount,
      attendances: attendances.map((m) => m.toEntity()).toList(),
    );
  }
}
