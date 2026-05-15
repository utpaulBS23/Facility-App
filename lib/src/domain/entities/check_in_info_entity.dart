class CheckInInfoEntity {
  CheckInInfoEntity({
    required this.location,
    required this.checkInTime,
    required this.checkInTimeRaw,
    required this.supervisorName,
    required this.latitude,
    required this.longitude,
  });

  final String location;
  final String checkInTime;
  // WHY: Raw format "yyyy-MM-dd HH:mm:ss" required by manual attendance API.
  final String checkInTimeRaw;
  final String supervisorName;
  final double latitude;
  final double longitude;
}
