import '../../core/utils/localized_text.dart';

enum StaffPinStatus { working, free, contractEnded }

/// An active facility with a known position.
class FacilityPinEntity {
  const FacilityPinEntity({
    required this.id,
    required this.name,
    this.nameBn = '',
    required this.address,
    required this.partnerName,
    required this.lat,
    required this.lng,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String nameBn;
  final String address;
  final String partnerName;
  final double lat;
  final double lng;
  final String? imageUrl;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}

/// An attendant with a known position.
class StaffPinEntity {
  const StaffPinEntity({
    required this.id,
    required this.uid,
    required this.name,
    this.nameBn = '',
    this.phoneNumber,
    this.imageUrl,
    this.facilityId,
    this.facilityName = '',
    this.facilityNameBn = '',
    required this.status,
    required this.lat,
    required this.lng,
    this.address,
  });

  final int id;
  final String uid;
  final String name;
  final String nameBn;
  final String? phoneNumber;

  /// Temporary URL (valid about 24 hours), so it is never cached long term.
  final String? imageUrl;
  final int? facilityId;
  final String facilityName;
  final String facilityNameBn;
  final StaffPinStatus status;
  final double lat;
  final double lng;
  final String? address;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

/// Attendant counts as reported by the server for the current filter.
class FacilityMapSummary {
  const FacilityMapSummary({
    this.working = 0,
    this.free = 0,
    this.contractEnded = 0,
  });

  final int working;
  final int free;
  final int contractEnded;
}

class FacilityMapEntity {
  const FacilityMapEntity({
    this.facilities = const [],
    this.staff = const [],
    this.summary = const FacilityMapSummary(),
  });

  final List<FacilityPinEntity> facilities;
  final List<StaffPinEntity> staff;
  final FacilityMapSummary summary;
}
