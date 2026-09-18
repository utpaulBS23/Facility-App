import '../models/manual_attendance_model.dart';
import '../../domain/entities/manual_attendance_entity.dart';
import 'date_time_parser.dart';

extension ManualAttendanceDataModelToEntity on ManualAttendanceDataModel {
  ManualAttendanceResponseEntity toEntity() => ManualAttendanceResponseEntity(
    id: id,
    shiftId: shiftId,
    status: status ?? 'pending',
    userName: userName ?? '',
    shiftDate: shiftDate ?? '',
    checkInTime: parseLocalIso(checkInTime),
    checkOutTime: parseLocalIso(checkOutTime),
    address: address ?? '',
    reason: reason ?? '',
    approverName: approverName,
  );
}
