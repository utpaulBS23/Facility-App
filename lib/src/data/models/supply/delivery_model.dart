import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/supply/delivery_status.dart';

part 'delivery_model.mapper.dart';

class DeliveryStatusHook extends MappingHook {
  const DeliveryStatusHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return DeliveryStatus.fromWireString(value);
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is DeliveryStatus) {
      return value.toWireString();
    }
    return value;
  }
}

@MappableClass(generateMethods: GenerateMethods.decode)
class DeliveryItemModel with DeliveryItemModelMappable {
  const DeliveryItemModel({
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
  @MappableField(key: 'stock_item_id')
  final int stockItemId;
  @MappableField(key: 'item_code')
  final String itemCode;
  @MappableField(key: 'item_name')
  final String itemName;
  final String unit;
  @MappableField(key: 'qty_expected')
  final double qtyExpected;
  @MappableField(key: 'qty_received')
  final double qtyReceived;
  @MappableField(key: 'is_verified')
  final bool isVerified;
  @MappableField(key: 'has_shortage')
  final bool hasShortage;

  static const fromJson = DeliveryItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class DeliveryModel with DeliveryModelMappable {
  const DeliveryModel({
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
  @MappableField(key: 'supply_request_id')
  final int supplyRequestId;
  @MappableField(key: 'request_code')
  final String requestCode;
  @MappableField(key: 'facility_id')
  final int facilityId;
  @MappableField(key: 'facility_name')
  final String facilityName;
  @MappableField(key: 'received_by')
  final int? receivedBy;
  @MappableField(key: 'received_by_name')
  final String? receivedByName;
  @MappableField(key: 'receipt_photo_url')
  final String? receiptPhotoUrl;
  @MappableField(key: 'delivery_notes')
  final String? deliveryNotes;
  @MappableField(hook: DeliveryStatusHook())
  final DeliveryStatus status;
  @MappableField(key: 'item_count')
  final int itemCount;
  final List<DeliveryItemModel> items;
  @MappableField(key: 'confirmed_at')
  final String? confirmedAt;
  @MappableField(key: 'created_at')
  final String createdAt;

  static const fromJson = DeliveryModelMapper.fromJson;
}
