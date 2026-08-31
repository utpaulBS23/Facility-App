import '../models/check_in_model.dart';
import '../../domain/entities/check_in_entity.dart';
import 'date_time_parser.dart';

extension CheckInWarningModelToEntity on CheckInWarningModel {
  CheckInWarningEntity toEntity() => CheckInWarningEntity(
    code: code ?? '',
    message: message ?? '',
    reasonRequired: reasonRequired ?? false,
  );
}

extension CheckInResponseModelToEntity on CheckInResponseModel {
  CheckInEntity toEntity() {
    final resolvedWarnings = warnings.isNotEmpty ? warnings : data.warnings;
    return CheckInEntity(
      attendanceId: data.attendanceId,
      shiftSlotId: data.shiftSlotId,
      checkInTime: parseLocalIso(data.checkInTime),
      approvalStatus: data.approvalStatus ?? '',
      checkInDistanceMeters: data.checkInDistanceMeters,
      lateByMinutes: data.lateByMinutes ?? 0,
      warnings: resolvedWarnings.map((warning) => warning.toEntity()).toList(),
    );
  }
}
