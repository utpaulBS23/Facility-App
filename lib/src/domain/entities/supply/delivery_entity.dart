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
    int? id,
    int? stockItemId,
    String? itemCode,
    String? itemName,
    String? unit,
    double? qtyExpected,
    double? qtyReceived,
    bool? isVerified,
    bool? hasShortage,
  }) {
    return DeliveryItemEntity(
      id: id ?? this.id,
      stockItemId: stockItemId ?? this.stockItemId,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      unit: unit ?? this.unit,
      qtyExpected: qtyExpected ?? this.qtyExpected,
      qtyReceived: qtyReceived ?? this.qtyReceived,
      isVerified: isVerified ?? this.isVerified,
      hasShortage: hasShortage ?? this.hasShortage,
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

  DeliveryEntity copyWith({
    int? id,
    int? supplyRequestId,
    String? requestCode,
    int? facilityId,
    String? facilityName,
    String? receivedByName,
    String? receiptPhotoUrl,
    String? deliveryNotes,
    DeliveryStatus? status,
    int? itemCount,
    List<DeliveryItemEntity>? items,
    String? confirmedAt,
    String? createdAt,
  }) {
    return DeliveryEntity(
      id: id ?? this.id,
      supplyRequestId: supplyRequestId ?? this.supplyRequestId,
      requestCode: requestCode ?? this.requestCode,
      facilityId: facilityId ?? this.facilityId,
      facilityName: facilityName ?? this.facilityName,
      receivedByName: receivedByName ?? this.receivedByName,
      receiptPhotoUrl: receiptPhotoUrl ?? this.receiptPhotoUrl,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      status: status ?? this.status,
      itemCount: itemCount ?? this.itemCount,
      items: items ?? this.items,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
