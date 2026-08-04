import '../../../../domain/entities/supply/delivery_entity.dart';

class ConfirmDeliveryItemUiState {
  const ConfirmDeliveryItemUiState({
    required this.stockItemId,
    required this.itemName,
    required this.category,
    required this.qtyExpected,
    required this.qtyReceived,
    required this.unit,
    this.isVerified = true,
  });

  final int stockItemId;
  final String itemName;
  final String category;
  final int qtyExpected;
  final int qtyReceived;
  final String unit;
  final bool isVerified;

  factory ConfirmDeliveryItemUiState.fromEntity(DeliveryItemEntity entity) {
    return ConfirmDeliveryItemUiState(
      stockItemId: entity.stockItemId,
      itemName: entity.itemName,
      category: entity.unit,
      qtyExpected: entity.qtyExpected.round(),
      qtyReceived: entity.qtyReceived > 0
          ? entity.qtyReceived.round()
          : entity.qtyExpected.round(),
      unit: entity.unit,
      isVerified: entity.isVerified,
    );
  }

  ConfirmDeliveryItemUiState copyWith({
    int? qtyReceived,
    bool? isVerified,
  }) {
    return ConfirmDeliveryItemUiState(
      stockItemId: stockItemId,
      itemName: itemName,
      category: category,
      qtyExpected: qtyExpected,
      qtyReceived: qtyReceived ?? this.qtyReceived,
      unit: unit,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
