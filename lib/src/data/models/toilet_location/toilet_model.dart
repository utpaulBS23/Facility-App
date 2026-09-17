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
  });

  final int id;
  final String name;
  final String? address;
  final String status;
  final double? averageRating;
  final double? lat;
  final double? lng;
  final String? mapsLink;

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
