import 'package:dart_mappable/dart_mappable.dart';

part 'file_delivery_complaint_request_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class FileDeliveryComplaintRequestModel
    with FileDeliveryComplaintRequestModelMappable {
  const FileDeliveryComplaintRequestModel({
    required this.deliveryItemId,
    required this.reportedQtyReceived,
    required this.reason,
    this.evidencePhotoUrl,
  });

  final int deliveryItemId;
  final double reportedQtyReceived;
  final String reason;
  final String? evidencePhotoUrl;
}
