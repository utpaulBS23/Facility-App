import '../models/check_in_model.dart';
import '../../domain/entities/check_in_entity.dart';

DateTime? _parseUtcIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    // WHY: API returns UTC strings without a 'Z' suffix; Dart parses bare ISO
    // strings as local time, so force UTC before converting.
    final value = (raw.contains('Z') || raw.contains('+')) ? raw : '${raw}Z';
    return DateTime.parse(value).toLocal();
  } catch (_) {
    return null;
  }
}

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
      checkInTime: _parseUtcIso(data.checkInTime),
      approvalStatus: data.approvalStatus ?? '',
      checkInDistanceMeters: data.checkInDistanceMeters,
      lateByMinutes: data.lateByMinutes ?? 0,
      warnings: resolvedWarnings.map((warning) => warning.toEntity()).toList(),
    );
  }
}
