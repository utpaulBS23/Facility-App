import '../models/attendance_model.dart';
import '../../domain/entities/attendance_entity.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return DateTime.parse(raw).toLocal();
  } catch (_) {
    return null;
  }
}

extension AttendanceApproverModelToEntity on AttendanceApproverModel {
  AttendanceApproverEntity toEntity() => AttendanceApproverEntity(
    id: id,
    name: name ?? '',
    uid: uid,
  );
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
    checkInTime: _parseUtcIso(checkInTime),
    checkOutTime: _parseUtcIso(checkOutTime),
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
