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
}

class DeliveryEntity {
  const DeliveryEntity({
    required this.id,
    required this.supplyRequestId,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.receivedByName,
    required this.receiptPhotoUrl,
    required this.deliveryNotes,
    required this.status,
    required this.itemCount,
    this.items = const [],
    required this.confirmedAt,
    required this.createdAt,
  });

  final int id;
  final int supplyRequestId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final String receivedByName;
  final String receiptPhotoUrl;
  final String deliveryNotes;
  final DeliveryStatus status;
  final int itemCount;
  final List<DeliveryItemEntity> items;
  final String confirmedAt;
  final String createdAt;
}
