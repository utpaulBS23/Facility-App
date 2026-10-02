import '../../../core/utils/localized_text.dart';

class TopDemandItemEntity {
  const TopDemandItemEntity({
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    this.itemNameBn = '',
    required this.unit,
    required this.totalMonthlyDemandQty,
  });

  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String itemNameBn;
  final String unit;
  final double totalMonthlyDemandQty;

  String localizedItemName(String languageCode) =>
      localizedText(languageCode, itemName, itemNameBn);
}
