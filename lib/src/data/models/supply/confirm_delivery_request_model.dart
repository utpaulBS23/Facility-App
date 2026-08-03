import 'package:dart_mappable/dart_mappable.dart';

part 'confirm_delivery_request_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ConfirmDeliveryRequestModel with ConfirmDeliveryRequestModelMappable {
  const ConfirmDeliveryRequestModel({
    this.receiptPhotoUrl,
    this.deliveryNotes,
  });

  final String? receiptPhotoUrl;
  final String? deliveryNotes;
}
