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
    required this.status,
    required this.userName,
    required this.shiftDate,
    required this.checkInTime,
    this.checkOutTime,
    required this.address,
    required this.reason,
    this.approverName,
  });

  final int id;
  final String status;
  final String userName;
  final String shiftDate;
  final String checkInTime;
  final String? checkOutTime;
  final String address;
  final String reason;
  final String? approverName;
}
