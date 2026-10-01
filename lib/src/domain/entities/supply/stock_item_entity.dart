import '../../../core/utils/localized_text.dart';

class StockItemEntity {
  const StockItemEntity({
    required this.id,
    this.partnerId,
    this.partnerName,
    required this.itemCode,
    required this.name,
    this.nameBn,
    required this.category,
    required this.unit,
    required this.unitPrice,
    required this.isActive,
  });

  final int id;

  /// Null means this is a shared/global catalog item usable by every partner.
  final int? partnerId;
  final String? partnerName;
  final String itemCode;
  final String name;
  final String? nameBn;
  final String category;
  final String unit;
  final double unitPrice;
  final bool isActive;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
