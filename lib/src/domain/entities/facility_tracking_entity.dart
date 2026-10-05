import '../../core/utils/localized_text.dart';

enum FacilityPinStatus { active, maintenance, inactive }

enum StaffPinStatus { working, free, contractEnded }

class FacilityPinEntity {
  const FacilityPinEntity({
    required this.id,
    required this.name,
    this.nameBn = '',
    required this.address,
    required this.partnerName,
    required this.lat,
    required this.lng,
    required this.status,
  });

  final int id;
  final String name;
  final String nameBn;
  final String address;
  final String partnerName;
  final double lat;
  final double lng;
  final FacilityPinStatus status;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}

class StaffPinEntity {
  const StaffPinEntity({
    required this.id,
    required this.uid,
    required this.name,
    this.nameBn = '',
    this.phoneNumber,
    this.imageUrl,
    required this.facilityId,
    required this.facilityName,
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
  final String? imageUrl;
  final int facilityId;
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

class FacilityTrackingEntity {
  const FacilityTrackingEntity({
    this.facilities = const [],
    this.staff = const [],
  });

  final List<FacilityPinEntity> facilities;
  final List<StaffPinEntity> staff;
}
