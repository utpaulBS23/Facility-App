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
  ManualAttendanceResponseEntity({required this.id, required this.status});

  final int id;
  final String status;
}
