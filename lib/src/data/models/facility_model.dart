import 'package:dart_mappable/dart_mappable.dart';

part 'facility_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityModel with FacilityModelMappable {
  FacilityModel({
    required this.id,
    this.partnerId,
    this.name,
    this.nameBn,
    this.address,
    this.addressBn,
    this.lat,
    this.lng,
    this.isFree,
    this.disableFriendly,
    this.isActive,
    this.isBhumijoSponsored,
    this.openingTime,
    this.closingTime,
    this.usageFee,
    this.videoUrl,
    this.activeTicketsCount,
    this.images = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'partner_id')
  final int? partnerId;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;
  final String? address;
  @MappableField(key: 'address_bn')
  final String? addressBn;
  final double? lat;
  final double? lng;
  @MappableField(key: 'is_free')
  final bool? isFree;
  @MappableField(key: 'disable_friendly')
  final bool? disableFriendly;
  @MappableField(key: 'is_active')
  final bool? isActive;
  @MappableField(key: 'is_bhumijo_sponsored')
  final bool? isBhumijoSponsored;
  @MappableField(key: 'opening_time')
  final String? openingTime;
  @MappableField(key: 'closing_time')
  final String? closingTime;
  @MappableField(key: 'usage_fee')
  final num? usageFee;
  @MappableField(key: 'video_url')
  final String? videoUrl;
  @MappableField(key: 'active_tickets_count')
  final int? activeTicketsCount;
  final List<String> images;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = FacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityMetaModel with FacilityMetaModelMappable {
  FacilityMetaModel({this.currentPage, this.lastPage, this.total});

  @MappableField(key: 'current_page')
  final int? currentPage;
  @MappableField(key: 'last_page')
  final int? lastPage;
  final int? total;

  static const fromJson = FacilityMetaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class FacilityListResponseModel with FacilityListResponseModelMappable {
  FacilityListResponseModel({this.data = const [], this.meta});

  final List<FacilityModel> data;
  final FacilityMetaModel? meta;

  static const fromJson = FacilityListResponseModelMapper.fromJson;
}
