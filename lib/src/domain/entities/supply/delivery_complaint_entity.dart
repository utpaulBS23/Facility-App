import 'delivery_complaint_status.dart';
import '../../../core/utils/localized_text.dart';

class DeliveryComplaintEntity {
  const DeliveryComplaintEntity({
    required this.id,
    required this.deliveryId,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.deliveryItemId,
    required this.itemCode,
    required this.itemName,
    this.itemNameBn = '',
    required this.expectedQty,
    required this.currentQtyReceived,
    required this.raisedByName,
    this.raisedByNameBn = '',
    required this.reportedQtyReceived,
    required this.reason,
    required this.evidencePhotoUrl,
    required this.status,
    required this.reviewedBySupervisorName,
    this.reviewedBySupervisorNameBn = '',
    required this.reviewedByOperationManagerName,
    this.reviewedByOperationManagerNameBn = '',
    required this.createdAt,
    required this.resolvedAt,
  });

  final int id;
  final int deliveryId;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final String facilityNameBn;
  final int deliveryItemId;
  final String itemCode;
  final String itemName;
  final String itemNameBn;
  final double expectedQty;
  final double currentQtyReceived;
  final String raisedByName;
  final String raisedByNameBn;
  final double reportedQtyReceived;
  final String reason;
  final String evidencePhotoUrl;
  final DeliveryComplaintStatus status;
  final String reviewedBySupervisorName;
  final String reviewedBySupervisorNameBn;
  final String reviewedByOperationManagerName;
  final String reviewedByOperationManagerNameBn;
  final String createdAt;
  final String resolvedAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedItemName(String languageCode) =>
      localizedText(languageCode, itemName, itemNameBn);

  String localizedRaisedByName(String languageCode) =>
      localizedText(languageCode, raisedByName, raisedByNameBn);

  String localizedReviewedBySupervisorName(String languageCode) =>
      localizedText(languageCode, reviewedBySupervisorName, reviewedBySupervisorNameBn);

  String localizedReviewedByOperationManagerName(String languageCode) =>
      localizedText(languageCode, reviewedByOperationManagerName, reviewedByOperationManagerNameBn);
}
