class TravelRouteCheckInRequestEntity {
  const TravelRouteCheckInRequestEntity({
    required this.taskId,
    this.facilityId,
    this.officeId,
    required this.latitude,
    required this.longitude,
    this.startType,
    this.startId,
  });

  final int taskId;
  final int? facilityId;
  final int? officeId;
  final double latitude;
  final double longitude;

  final String? startType;
  final int? startId;
}

class TravelRouteCheckInEntity {
  const TravelRouteCheckInEntity({
    required this.taskId,
    this.facilityId,
    this.officeId,
    required this.travelTrackingExcluded,
    this.travelOriginType,
    this.travelOriginId,
    this.originLat,
    this.originLng,
    this.originName,
  });

  final int taskId;
  final int? facilityId;
  final int? officeId;
  final bool travelTrackingExcluded;
  final String? travelOriginType;
  final int? travelOriginId;
  final double? originLat;
  final double? originLng;
  final String? originName;
}
