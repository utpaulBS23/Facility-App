import 'package:dart_mappable/dart_mappable.dart';

part 'confirm_delivery_request_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ConfirmDeliveryRequestModel with ConfirmDeliveryRequestModelMappable {
  const ConfirmDeliveryRequestModel({
    required this.items,
    this.receiptPhotoUrl,
    this.deliveryNotes,
  });

  final List<ConfirmDeliveryItemModel> items;
  final String? receiptPhotoUrl;
  final String? deliveryNotes;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ConfirmDeliveryItemModel with ConfirmDeliveryItemModelMappable {
  const ConfirmDeliveryItemModel({
    required this.stockItemId,
    required this.qtyReceived,
    required this.isVerified,
  });

  final int stockItemId;
  final double qtyReceived;
  final bool isVerified;
}
