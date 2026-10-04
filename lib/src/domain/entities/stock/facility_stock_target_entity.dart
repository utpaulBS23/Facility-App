import '../../../core/utils/localized_text.dart';

class FacilityStockTargetEntity {
  const FacilityStockTargetEntity({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    this.itemNameBn = '',
    required this.unit,
    required this.monthlyTargetQty,
    required this.updatedByName,
    this.updatedByNameBn = '',
    required this.updatedAt,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  final String facilityNameBn;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String itemNameBn;
  final String unit;
  final double monthlyTargetQty;
  final String updatedByName;
  final String updatedByNameBn;
  final String updatedAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedItemName(String languageCode) =>
      localizedText(languageCode, itemName, itemNameBn);

  String localizedUpdatedByName(String languageCode) =>
      localizedText(languageCode, updatedByName, updatedByNameBn);
}
