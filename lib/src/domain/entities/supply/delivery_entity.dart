import 'delivery_status.dart';

class DeliveryItemEntity {
  const DeliveryItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyExpected,
    required this.qtyReceived,
    required this.isVerified,
    required this.hasShortage,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyExpected;
  final double qtyReceived;
  final bool isVerified;
  final bool hasShortage;

  DeliveryItemEntity copyWith({
    double? qtyReceived,
    bool? isVerified,
  }) {
    return DeliveryItemEntity(
      id: id,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      qtyExpected: qtyExpected,
      qtyReceived: qtyReceived ?? this.qtyReceived,
      isVerified: isVerified ?? this.isVerified,
      hasShortage: hasShortage,
    );
  }
}

class DeliveryEntity {
  const DeliveryEntity({
    required this.id,
    required this.supplyRequestId,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    this.receivedBy,
    this.receivedByName,
    this.receiptPhotoUrl,
    this.deliveryNotes,
    required this.status,
    required this.itemCount,
    this.items = const [],
    this.confirmedAt,
    required this.createdAt,
  });

  final int id;
  final int supplyRequestId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int? receivedBy;
  final String? receivedByName;
  final String? receiptPhotoUrl;
  final String? deliveryNotes;
  final DeliveryStatus status;
  final int itemCount;
  final List<DeliveryItemEntity> items;
  final String? confirmedAt;
  final String createdAt;

  DeliveryEntity copyWith({List<DeliveryItemEntity>? items}) {
    return DeliveryEntity(
      id: id,
      supplyRequestId: supplyRequestId,
      requestCode: requestCode,
      facilityId: facilityId,
      facilityName: facilityName,
      receivedBy: receivedBy,
      receivedByName: receivedByName,
      receiptPhotoUrl: receiptPhotoUrl,
      deliveryNotes: deliveryNotes,
      status: status,
      itemCount: itemCount,
      items: items ?? this.items,
      confirmedAt: confirmedAt,
      createdAt: createdAt,
    );
  }

  /// Applies user-edited received quantities, keyed by [DeliveryItemEntity.stockItemId].
  DeliveryEntity withEditedQuantities(Map<int, int> editedQuantities) {
    if (editedQuantities.isEmpty) {
      return this;
    }

    return copyWith(
      items: items.map((item) {
        final editedQty = editedQuantities[item.stockItemId];

        return editedQty == null
            ? item
            : item.copyWith(qtyReceived: editedQty.toDouble());
      }).toList(),
    );
  }
}
