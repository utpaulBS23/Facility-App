import 'package:dart_mappable/dart_mappable.dart';

part 'delivery_complaint_response_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DeliveryComplaintModel with DeliveryComplaintModelMappable {
  const DeliveryComplaintModel({
    required this.id,
    required this.deliveryId,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.deliveryItemId,
    required this.itemCode,
    required this.itemName,
    required this.expectedQty,
    required this.currentQtyReceived,
    this.raisedBy,
    this.raisedByName,
    required this.reportedQtyReceived,
    required this.reason,
    this.evidencePhotoUrl,
    this.status,
    this.reviewedBySupervisor,
    this.reviewedByOperationManager,
    required this.createdAt,
    this.resolvedAt,
  });

  final int id;
  final int deliveryId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int deliveryItemId;
  final String itemCode;
  final String itemName;
  final double expectedQty;
  final double currentQtyReceived;
  final int? raisedBy;
  final String? raisedByName;
  final double reportedQtyReceived;
  final String reason;
  final String? evidencePhotoUrl;
  final String? status;
  final int? reviewedBySupervisor;
  final int? reviewedByOperationManager;
  final String createdAt;
  final String? resolvedAt;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class DeliveryComplaintResponseModel with DeliveryComplaintResponseModelMappable {
  const DeliveryComplaintResponseModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final DeliveryComplaintModel? data;

  static const fromJson = DeliveryComplaintResponseModelMapper.fromJson;
}
