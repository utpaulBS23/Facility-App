import 'package:dart_mappable/dart_mappable.dart';

import 'supply_pagination_meta_model.dart';

part 'delivery_complaint_model.mapper.dart';

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
    this.reason,
    this.evidencePhotoUrl,
    required this.status,
    this.reviewedBySupervisor,
    this.reviewedBySupervisorName,
    this.reviewedByOperationManager,
    this.reviewedByOperationManagerName,
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
  final String? reason;
  final String? evidencePhotoUrl;
  final String status;
  final int? reviewedBySupervisor;
  final String? reviewedBySupervisorName;
  final int? reviewedByOperationManager;
  final String? reviewedByOperationManagerName;
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

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class DeliveryComplaintListResponseModel
    with DeliveryComplaintListResponseModelMappable {
  const DeliveryComplaintListResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.meta,
  });

  final bool success;
  final String message;
  final List<DeliveryComplaintModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = DeliveryComplaintListResponseModelMapper.fromJson;
}
