import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/supply/confirm_delivery_request.dart';
import '../entities/supply/delivery_complaint_entity.dart';
import '../entities/supply/delivery_entity.dart';
import '../entities/supply/file_delivery_complaint_request.dart';

abstract base class DeliveryRepository extends Repository {
  Future<Result<DeliveryEntity?, Failure>> getDeliveryForSupplyRequest({
    required int partnerId,
    required String requestCode,
  });

  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest({
    required int partnerId,
    required int supplyRequestId,
  });

  Future<Result<DeliveryEntity, Failure>> confirmDelivery({
    required int partnerId,
    required int deliveryId,
    required ConfirmDeliveryRequest request,
  });

  Future<Result<DeliveryComplaintEntity, Failure>> fileDeliveryComplaint({
    required int partnerId,
    required int deliveryId,
    required FileDeliveryComplaintRequest request,
  });
}
