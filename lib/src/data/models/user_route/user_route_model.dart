import 'package:dart_mappable/dart_mappable.dart';

part 'user_route_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class RouteFacilityModel with RouteFacilityModelMappable {
  const RouteFacilityModel({this.id, this.name});

  final int? id;
  final String? name;

  static const fromJson = RouteFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class RoutePingModel with RoutePingModelMappable {
  const RoutePingModel({this.lat, this.lng, this.recordedAt});

  final num? lat;
  final num? lng;
  final String? recordedAt;

  static const fromJson = RoutePingModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class RouteLegModel with RouteLegModelMappable {
  const RouteLegModel({
    required this.routeLegId,
    this.fromFacility,
    this.toFacility,
    this.fromTime,
    this.toTime,
    this.trail = const [],
    this.travelExpenseId,
  });

  final int routeLegId;
  final RouteFacilityModel? fromFacility;
  final RouteFacilityModel? toFacility;
  final String? fromTime;
  final String? toTime;
  final List<RoutePingModel> trail;
  final int? travelExpenseId;

  static const fromJson = RouteLegModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class UserRouteDataModel with UserRouteDataModelMappable {
  const UserRouteDataModel({this.legs = const []});

  final List<RouteLegModel> legs;

  static const fromJson = UserRouteDataModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class UserRouteResponseModel with UserRouteResponseModelMappable {
  const UserRouteResponseModel({this.data});

  final UserRouteDataModel? data;

  static const fromJson = UserRouteResponseModelMapper.fromJson;
}
