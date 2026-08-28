class TravelRouteCheckInRequestEntity {
  const TravelRouteCheckInRequestEntity({
    required this.taskId,
    required this.facilityId,
    required this.latitude,
    required this.longitude,
  });

  final int taskId;
  final int facilityId;
  final double latitude;
  final double longitude;
}

class TravelRouteCheckInEntity {
  const TravelRouteCheckInEntity({
    required this.taskId,
    required this.facilityId,
    required this.travelTrackingExcluded,
  });

  final int taskId;
  final int facilityId;
  final bool travelTrackingExcluded;
}
