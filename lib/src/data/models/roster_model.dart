import 'package:dart_mappable/dart_mappable.dart';

part 'roster_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftGlobalConfigDataModel with ShiftGlobalConfigDataModelMappable {
  ShiftGlobalConfigDataModel({required this.weekStartDay});

  @MappableField(key: 'week_start_day')
  final int weekStartDay;

  static const fromJson = ShiftGlobalConfigDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftGlobalConfigResponseModel
    with ShiftGlobalConfigResponseModelMappable {
  ShiftGlobalConfigResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  final bool success;
  final String? message;
  final ShiftGlobalConfigDataModel? data;

  static const fromJson = ShiftGlobalConfigResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterFacilityModel with RosterFacilityModelMappable {
  RosterFacilityModel({required this.id, this.name, this.nameBn});

  final int id;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;

  static const fromJson = RosterFacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterCreatorModel with RosterCreatorModelMappable {
  RosterCreatorModel({required this.id, this.fullName, this.role});

  final int id;
  @MappableField(key: 'full_name')
  final String? fullName;
  final String? role;

  static const fromJson = RosterCreatorModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterDataModel with RosterDataModelMappable {
  RosterDataModel({
    required this.id,
    required this.facilityId,
    this.facility,
    this.createdBy,
    this.weekStartDate,
    this.weekEndDate,
    this.status,
    this.publishedAt,
    this.totalShifts,
    this.filledShifts,
    this.notes,
    this.offDays = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'facility_id')
  final int facilityId;
  final RosterFacilityModel? facility;
  @MappableField(key: 'created_by')
  final RosterCreatorModel? createdBy;
  @MappableField(key: 'week_start_date')
  final String? weekStartDate;
  @MappableField(key: 'week_end_date')
  final String? weekEndDate;
  final String? status;
  @MappableField(key: 'published_at')
  final String? publishedAt;
  @MappableField(key: 'total_shifts')
  final int? totalShifts;
  @MappableField(key: 'filled_shifts')
  final int? filledShifts;
  final String? notes;
  @MappableField(key: 'off_days')
  final List<int> offDays;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = RosterDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterResponseModel with RosterResponseModelMappable {
  RosterResponseModel({required this.success, this.message, this.data});

  final bool success;
  final String? message;
  final RosterDataModel? data;

  static const fromJson = RosterResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterMetaModel with RosterMetaModelMappable {
  RosterMetaModel({this.currentPage, this.lastPage, this.total});

  @MappableField(key: 'current_page')
  final int? currentPage;
  @MappableField(key: 'last_page')
  final int? lastPage;
  final int? total;

  static const fromJson = RosterMetaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class RosterListResponseModel with RosterListResponseModelMappable {
  RosterListResponseModel({this.data = const [], this.meta});

  final List<RosterDataModel> data;
  final RosterMetaModel? meta;

  static const fromJson = RosterListResponseModelMapper.fromJson;
}
