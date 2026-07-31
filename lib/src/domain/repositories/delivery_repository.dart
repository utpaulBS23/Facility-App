import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/supply/delivery_entity.dart';

abstract base class DeliveryRepository extends Repository {
  Future<Result<DeliveryEntity?, Failure>> getDeliveryForSupplyRequest({
    required int partnerId,
    required String requestCode,
  });

  Future<Result<DeliveryEntity, Failure>> confirmDelivery({
    required int partnerId,
    required int deliveryId,
    String? receiptPhotoUrl,
    String? deliveryNotes,
  });
}
