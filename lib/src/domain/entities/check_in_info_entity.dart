import '../../core/base/failure.dart';

class CheckInInfoEntity {
  CheckInInfoEntity({
    required this.checkInTime,
    required this.checkInTimeRaw,
    required this.supervisorName,
    this.location,
    this.latitude,
    this.longitude,
    this.locationFailure,
  });

  final String checkInTime;
  // WHY: Raw format "yyyy-MM-dd HH:mm:ss" required by manual attendance API.
  final String checkInTimeRaw;
  final String supervisorName;
  final String? location;
  final double? latitude;
  final double? longitude;
  final Failure? locationFailure;

  bool get hasLocation => latitude != null && longitude != null;
}
