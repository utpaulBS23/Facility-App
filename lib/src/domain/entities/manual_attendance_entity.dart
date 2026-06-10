class ManualAttendanceRequestEntity {
  ManualAttendanceRequestEntity({
    required this.shiftId,
    required this.reason,
    required this.checkInTime,
    required this.lat,
    required this.lng,
    required this.address,
  });

  final int shiftId;
  final String reason;
  final String checkInTime;
  final double lat;
  final double lng;
  final String address;
}

class ManualAttendanceResponseEntity {
  ManualAttendanceResponseEntity({
    required this.id,
    required this.shiftId,
    required this.status,
    required this.userName,
    required this.shiftDate,
    this.checkInTime,
    this.checkOutTime,
    required this.address,
    required this.reason,
    this.approverName,
  });

  final int id;
  final int shiftId;
  final String status;
  final String userName;
  final String shiftDate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String address;
  final String reason;
  final String? approverName;
}
