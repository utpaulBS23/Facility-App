class FacilityEntity {
  const FacilityEntity({
    required this.id,
    required this.partnerId,
    required this.name,
    this.nameBn,
    required this.address,
    this.addressBn,
    required this.lat,
    required this.lng,
    required this.isFree,
    required this.disableFriendly,
    required this.isActive,
    required this.isBhumijoSponsored,
    this.openingTime,
    this.closingTime,
    this.usageFee,
    this.videoUrl,
    this.activeTicketsCount = 0,
    this.images = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int partnerId;
  final String name;
  final String? nameBn;
  final String address;
  final String? addressBn;
  final double lat;
  final double lng;
  final bool isFree;
  final bool disableFriendly;
  final bool isActive;
  final bool isBhumijoSponsored;
  final String? openingTime;
  final String? closingTime;
  final num? usageFee;
  final String? videoUrl;
  final int activeTicketsCount;
  final List<String> images;
  final String? createdAt;
  final String? updatedAt;
}

class FacilityListEntity {
  const FacilityListEntity({
    required this.facilities,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<FacilityEntity> facilities;
  final int currentPage;
  final int lastPage;
  final int total;
}
