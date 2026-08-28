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
    required this.facilityId,
    this.travelTrackingExcluded,
  });

  @MappableField(key: 'task_id')
  final int taskId;

  @MappableField(key: 'facility_id')
  final int facilityId;

  @MappableField(key: 'travel_tracking_excluded')
  final bool? travelTrackingExcluded;

  static const fromJson = TravelRouteCheckInModelMapper.fromJson;

  TravelRouteCheckInEntity toEntity() => TravelRouteCheckInEntity(
        taskId: taskId,
        facilityId: facilityId,
        travelTrackingExcluded: travelTrackingExcluded ?? false,
      );
}
