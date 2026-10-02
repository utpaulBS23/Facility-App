import '../../core/utils/localized_text.dart';

/// One row of partner/global master data — a configurable dropdown option
/// (e.g. a transport mode, filtered by `category`).
class MasterDataItemEntity {
  const MasterDataItemEntity({
    required this.id,
    required this.value,
    required this.label,
    this.color,
    required this.isActive,
    required this.sortOrder,
    this.labelBn = '',
  });

  final int id;
  final String value;
  final String label;
  final String labelBn;
  final String? color;
  final bool isActive;
  final int sortOrder;

  String localizedLabel(String languageCode) =>
      localizedText(languageCode, label, labelBn);
}
