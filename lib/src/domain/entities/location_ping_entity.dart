class LocationPingEntity {
  const LocationPingEntity({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    this.accuracy,
    this.battery,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double? accuracy;
  final int? battery;
}

class LocationPingSyncRequestEntity {
  const LocationPingSyncRequestEntity({
    required this.taskId,
    required this.pings,
  });

  final int taskId;
  final List<LocationPingEntity> pings;
}
