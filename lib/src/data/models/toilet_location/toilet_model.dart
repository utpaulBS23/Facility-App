import 'package:dart_mappable/dart_mappable.dart';

part 'toilet_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletModel with ToiletModelMappable {
  const ToiletModel({
    required this.id,
    required this.name,
    this.address,
    required this.status,
    this.averageRating,
    this.lat,
    this.lng,
    this.mapsLink,
    this.facilityType,
    this.supervisor,
    this.openingTime,
    this.closingTime,
    this.is24Hours,
    this.operatingDays,
    this.isFree,
    this.usageFee,
    this.disableFriendly,
    this.visitsToday,
    this.revenue,
  });

  final int id;
  final String name;
  final String? address;
  final String status;
  final double? averageRating;
  final double? lat;
  final double? lng;
  final String? mapsLink;
  final String? facilityType;

  /// `{id, name}`; null when no supervisor is assigned.
  final Map<String, dynamic>? supervisor;

  /// `HH:mm:ss`.
  final String? openingTime;
  final String? closingTime;
  final bool? is24Hours;

  /// Lower-case weekday keys such as `sat`, `sun`.
  final List<String>? operatingDays;
  final bool? isFree;
  final num? usageFee;
  final bool? disableFriendly;
  final int? visitsToday;
  final num? revenue;

  static const fromJson = ToiletModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletSummaryModel with ToiletSummaryModelMappable {
  const ToiletSummaryModel({
    this.total,
    this.active,
    this.inactive,
    this.maintenance,
  });

  final int? total;
  final int? active;
  final int? inactive;
  final int? maintenance;

  static const fromJson = ToiletSummaryModelMapper.fromJson;
}
