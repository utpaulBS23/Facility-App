import '../models/manual_attendance_model.dart';
import '../../domain/entities/manual_attendance_entity.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return DateTime.parse(raw).toLocal();
  } catch (_) {
    return null;
  }
}

extension ManualAttendanceDataModelToEntity on ManualAttendanceDataModel {
  ManualAttendanceResponseEntity toEntity() => ManualAttendanceResponseEntity(
    id: id,
    shiftId: shiftId,
    status: status ?? 'pending',
    userName: userName ?? '',
    shiftDate: shiftDate ?? '',
    checkInTime: _parseUtcIso(checkInTime),
    checkOutTime: _parseUtcIso(checkOutTime),
    address: address ?? '',
    reason: reason ?? '',
    approverName: approverName,
  );
}
