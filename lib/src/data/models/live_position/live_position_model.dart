import 'package:dart_mappable/dart_mappable.dart';

part 'live_position_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LivePositionFacilityModel with LivePositionFacilityModelMappable {
  const LivePositionFacilityModel({required this.id, this.name});

  final int id;
  final String? name;

  static const fromJson = LivePositionFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LivePositionModel with LivePositionModelMappable {
  const LivePositionModel({
    required this.userId,
    this.name,
    this.lat,
    this.lng,
    this.accuracyMeters,
    this.facility,
    this.recordedAt,
    this.batteryLevel,
    this.online,
    this.activity,
    this.withinGeofence,
  });

  final int userId;
  final String? name;
  final num? lat;
  final num? lng;
  final num? accuracyMeters;
  final LivePositionFacilityModel? facility;
  final String? recordedAt;
  final num? batteryLevel;
  final bool? online;
  final String? activity;
  final bool? withinGeofence;

  static const fromJson = LivePositionModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LivePositionLinksModel with LivePositionLinksModelMappable {
  const LivePositionLinksModel({this.next});

  final String? next;

  static const fromJson = LivePositionLinksModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LivePositionsResponseModel with LivePositionsResponseModelMappable {
  const LivePositionsResponseModel({this.data = const [], this.links});

  final List<LivePositionModel> data;
  final LivePositionLinksModel? links;

  static const fromJson = LivePositionsResponseModelMapper.fromJson;
}
