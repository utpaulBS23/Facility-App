import '../../../core/utils/localized_text.dart';

class StockAllocationEntity {
  const StockAllocationEntity({
    required this.id,
    required this.allocationCode,
    required this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.allocatedByName,
    this.allocatedByNameBn = '',
    required this.sourceRequestCode,
    required this.notes,
    required this.items,
    required this.allocatedAt,
  });

  final int id;
  final String allocationCode;
  final int facilityId;
  final String facilityName;
  final String facilityNameBn;
  final String allocatedByName;
  final String allocatedByNameBn;
  final String sourceRequestCode;
  final String notes;
  final List<StockAllocationItemEntity> items;
  final String allocatedAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedAllocatedByName(String languageCode) =>
      localizedText(languageCode, allocatedByName, allocatedByNameBn);
}

class StockAllocationItemEntity {
  const StockAllocationItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    this.itemNameBn = '',
    required this.unit,
    required this.qty,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String itemNameBn;
  final String unit;
  final double qty;

  String localizedItemName(String languageCode) =>
      localizedText(languageCode, itemName, itemNameBn);
}
