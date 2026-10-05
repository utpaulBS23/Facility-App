import '../../domain/entities/facility_map_entity.dart';
import '../models/facility_map/facility_map_model.dart';

/// Only active facilities are shown on the map.
const _activeFacilityStatus = 'active';

bool _hasPosition(num? lat, num? lng) =>
    lat != null && lng != null && !(lat == 0 && lng == 0);

extension FacilityMapFacilityModelToEntity on FacilityMapFacilityModel {
  FacilityPinEntity toEntity() => FacilityPinEntity(
    id: id,
    name: name ?? '',
    address: address ?? '',
    partnerName: partnerName ?? '',
    lat: lat!.toDouble(),
    lng: lng!.toDouble(),
    imageUrl: image,
  );
}

extension FacilityMapStaffModelToEntity on FacilityMapStaffModel {
  StaffPinEntity toEntity() {
    final facility = facilities.firstOrNull;
    return StaffPinEntity(
      id: id,
      uid: uid ?? '',
      name: name ?? '',
      phoneNumber: phoneNumber,
      imageUrl: image,
      facilityId: facility?.id,
      facilityName: facility?.name ?? '',
      status: switch (status) {
        'working' => StaffPinStatus.working,
        'contract_ended' => StaffPinStatus.contractEnded,
        _ => StaffPinStatus.free,
      },
      lat: lat!.toDouble(),
      lng: lng!.toDouble(),
      address: address,
    );
  }
}

extension FacilityMapResponseModelToEntity on FacilityMapResponseModel {
  FacilityMapEntity toEntity() {
    final data = this.data;
    return FacilityMapEntity(
      facilities: [
        for (final f in data?.facilities ?? const <FacilityMapFacilityModel>[])
          if (f.status == _activeFacilityStatus && _hasPosition(f.lat, f.lng))
            f.toEntity(),
      ],
      staff: [
        for (final s in data?.staff ?? const <FacilityMapStaffModel>[])
          if (_hasPosition(s.lat, s.lng)) s.toEntity(),
      ],
      summary: FacilityMapSummary(
        working: summary?.working ?? 0,
        free: summary?.free ?? 0,
        contractEnded: summary?.contractEnded ?? 0,
      ),
    );
  }
}
