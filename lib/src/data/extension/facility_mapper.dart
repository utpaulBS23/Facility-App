import '../../domain/entities/facility_entity.dart';
import '../models/facility_model.dart';

extension FacilityModelToEntity on FacilityModel {
  FacilityEntity toEntity() => FacilityEntity(
    id: id,
    partnerId: partnerId ?? 0,
    name: name ?? '',
    nameBn: nameBn,
    address: address ?? '',
    addressBn: addressBn,
    lat: lat ?? 0,
    lng: lng ?? 0,
    isFree: isFree ?? false,
    disableFriendly: disableFriendly ?? false,
    isActive: isActive ?? false,
    isBhumijoSponsored: isBhumijoSponsored ?? false,
    openingTime: openingTime,
    closingTime: closingTime,
    usageFee: usageFee,
    videoUrl: videoUrl,
    activeTicketsCount: activeTicketsCount ?? 0,
    images: images,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension FacilityListResponseModelToEntity on FacilityListResponseModel {
  FacilityListEntity toEntity() => FacilityListEntity(
    facilities: data.map((f) => f.toEntity()).toList(),
    currentPage: meta?.currentPage ?? 1,
    lastPage: meta?.lastPage ?? 1,
    total: meta?.total ?? data.length,
  );
}
