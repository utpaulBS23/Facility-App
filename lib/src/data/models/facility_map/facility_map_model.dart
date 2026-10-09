import 'package:dart_mappable/dart_mappable.dart';

part 'facility_map_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapFacilityModel with FacilityMapFacilityModelMappable {
  const FacilityMapFacilityModel({
    required this.id,
    this.partnerName,
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.status,
    this.image,
  });

  final int id;
  final String? partnerName;
  final String? name;
  final String? address;
  final num? lat;
  final num? lng;
  final String? status;
  final String? image;

  static const fromJson = FacilityMapFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapStaffFacilityModel with FacilityMapStaffFacilityModelMappable {
  const FacilityMapStaffFacilityModel({required this.id, this.name});

  final int id;
  final String? name;

  static const fromJson = FacilityMapStaffFacilityModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapStaffModel with FacilityMapStaffModelMappable {
  const FacilityMapStaffModel({
    required this.id,
    this.uid,
    this.name,
    this.phoneNumber,
    this.facilities = const [],
    this.isActive,
    this.status,
    this.lat,
    this.lng,
    this.address,
    this.image,
  });

  final int id;
  final String? uid;
  final String? name;
  final String? phoneNumber;
  final List<FacilityMapStaffFacilityModel> facilities;
  final bool? isActive;
  final String? status;
  final num? lat;
  final num? lng;
  final String? address;
  final String? image;

  static const fromJson = FacilityMapStaffModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapDataModel with FacilityMapDataModelMappable {
  const FacilityMapDataModel({
    this.facilities = const [],
    this.staff = const [],
  });

  final List<FacilityMapFacilityModel> facilities;
  final List<FacilityMapStaffModel> staff;

  static const fromJson = FacilityMapDataModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapSummaryModel with FacilityMapSummaryModelMappable {
  const FacilityMapSummaryModel({this.working, this.free, this.contractEnded});

  final int? working;
  final int? free;
  final int? contractEnded;

  static const fromJson = FacilityMapSummaryModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityMapResponseModel with FacilityMapResponseModelMappable {
  const FacilityMapResponseModel({this.data, this.summary});

  final FacilityMapDataModel? data;
  final FacilityMapSummaryModel? summary;

  static const fromJson = FacilityMapResponseModelMapper.fromJson;
}
