import '../models/check_out_model.dart';
import '../../domain/entities/check_out_entity.dart';
import 'date_time_parser.dart';

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
    checkInTime: parseLocalIso(data.checkInTime),
    checkOutTime: parseLocalIso(data.checkOutTime),
    totalHours: data.totalHours ?? 0,
    approvalStatus: data.approvalStatus ?? '',
    warnings: warnings.map((warning) => warning.toEntity()).toList(),
  );
}
