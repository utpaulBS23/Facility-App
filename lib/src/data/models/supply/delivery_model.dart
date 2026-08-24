import 'package:dart_mappable/dart_mappable.dart';

part 'delivery_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyExpected;
  final double qtyReceived;
  final bool isVerified;
  final bool hasShortage;

  static const fromJson = DeliveryItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final int supplyRequestId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int? receivedBy;
  final String? receivedByName;
  final String? receiptPhotoUrl;
  final String? deliveryNotes;
  final String status;
  final int itemCount;
  final List<DeliveryItemModel> items;
  final String? confirmedAt;
  final String createdAt;

  static const fromJson = DeliveryModelMapper.fromJson;
}
