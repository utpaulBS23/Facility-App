import '../../core/utils/localized_text.dart';

class ManualAttendanceRequestEntity {
  ManualAttendanceRequestEntity({
    required this.shiftId,
    required this.reason,
    required this.checkInTime,
    this.lat,
    this.lng,
    required this.address,
  });

  final int shiftId;
  final String reason;
  final String checkInTime;
  // WHY nullable: this is the escape hatch for when location detection
  // itself failed — requiring coordinates here would defeat the purpose.
  final double? lat;
  final double? lng;
  final String address;
}

class ManualAttendanceResponseEntity {
  ManualAttendanceResponseEntity({
    required this.id,
    required this.shiftId,
    required this.status,
    required this.userName,
    this.userNameBn = '',
    required this.shiftDate,
    this.checkInTime,
    this.checkOutTime,
    required this.address,
    required this.reason,
    this.approverName,
    this.approverNameBn = '',
  });

  final int id;
  final int shiftId;
  final String status;
  final String userName;
  final String userNameBn;
  final String shiftDate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String address;
  final String reason;
  final String? approverName;
  final String approverNameBn;

  String localizedUserName(String languageCode) =>
      localizedText(languageCode, userName, userNameBn);

  String? localizedApproverName(String languageCode) =>
      localizedTextOrNull(languageCode, approverName, approverNameBn);
}
