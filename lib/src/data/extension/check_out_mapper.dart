import '../models/check_out_model.dart';
import '../../domain/entities/check_out_entity.dart';

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

extension CheckOutWarningModelToEntity on CheckOutWarningModel {
  CheckOutWarningEntity toEntity() => CheckOutWarningEntity(
    code: code ?? '',
    message: message ?? '',
    reasonRequired: reasonRequired ?? false,
  );
}

extension CheckOutResponseModelToEntity on CheckOutResponseModel {
  CheckOutEntity toEntity() => CheckOutEntity(
    attendanceId: data.attendanceId,
    checkInTime: _parseUtcIso(data.checkInTime),
    checkOutTime: _parseUtcIso(data.checkOutTime),
    totalHours: data.totalHours ?? 0,
    approvalStatus: data.approvalStatus ?? '',
    warnings: warnings.map((warning) => warning.toEntity()).toList(),
  );
}
