import '../../core/utils/localized_text.dart';

/// A facility as needed by the door-control screen (icon, name, address).
class FacilityEntity {
  const FacilityEntity({
    required this.id,
    required this.name,
    this.nameBn = '',
    required this.address,
  });

  final int id;
  final String name;
  final String nameBn;
  final String address;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
