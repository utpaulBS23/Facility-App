class TravelRouteCheckInRequestEntity {
  const TravelRouteCheckInRequestEntity({
    required this.taskId,
    required this.facilityId,
    required this.latitude,
    required this.longitude,
    this.startType,
    this.startId,
  });

  final int taskId;
  final int facilityId;
  final double latitude;
  final double longitude;

  // WHY: where this trip started from — sourced from the visit list's
  // `travel_origin_type`/`travel_origin_id`, absent for the first leg of
  // the day.
  final String? startType;
  final int? startId;
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
