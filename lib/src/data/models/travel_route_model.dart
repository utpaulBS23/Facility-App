import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/travel_route_entity.dart';

part 'travel_route_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class TravelRouteCheckInResponseModel
    with TravelRouteCheckInResponseModelMappable {
  TravelRouteCheckInResponseModel({required this.data});

  final TravelRouteCheckInModel data;

  static const fromJson = TravelRouteCheckInResponseModelMapper.fromJson;

  TravelRouteCheckInEntity toEntity() => data.toEntity();
}

@MappableClass(generateMethods: GenerateMethods.decode)
class TravelRouteCheckInModel with TravelRouteCheckInModelMappable {
  TravelRouteCheckInModel({
    required this.taskId,
    this.facilityId,
    this.officeId,
    this.travelTrackingExcluded,
    this.travelOriginType,
    this.travelOriginId,
    this.originLat,
    this.originLng,
    this.originName,
  });

  @MappableField(key: 'task_id')
  final int taskId;

  @MappableField(key: 'facility_id')
  final int? facilityId;

  @MappableField(key: 'office_id')
  final int? officeId;

  @MappableField(key: 'travel_tracking_excluded')
  final bool? travelTrackingExcluded;

  @MappableField(key: 'travel_origin_type')
  final String? travelOriginType;

  @MappableField(key: 'travel_origin_id')
  final int? travelOriginId;

  @MappableField(key: 'origin_lat')
  final double? originLat;

  @MappableField(key: 'origin_lng')
  final double? originLng;

  @MappableField(key: 'origin_name')
  final String? originName;

  static const fromJson = TravelRouteCheckInModelMapper.fromJson;

  TravelRouteCheckInEntity toEntity() => TravelRouteCheckInEntity(
        taskId: taskId,
        facilityId: facilityId,
        officeId: officeId,
        travelTrackingExcluded: travelTrackingExcluded ?? false,
        travelOriginType: travelOriginType,
        travelOriginId: travelOriginId,
        originLat: originLat,
        originLng: originLng,
        originName: originName,
      );
}
