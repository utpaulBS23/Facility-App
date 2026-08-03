import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/supply/confirm_delivery_request.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../extension/delivery_mapper.dart';
import '../models/supply/delivery_response_models.dart';
import '../services/network/rest_client.dart';

final class DeliveryRepositoryImpl extends DeliveryRepository {
  DeliveryRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<DeliveryEntity?, Failure>> getDeliveryForSupplyRequest({
    required int partnerId,
    required String requestCode,
  }) {
    return asyncGuard(() async {
      final response = await remote.getDeliveries(
        partnerId: partnerId,
        search: requestCode,
      );
      final responseModel = DeliveryListResponseModel.fromJson(response.data);
      final deliveries = responseModel.toEntityList();
      for (final delivery in deliveries) {
        if (delivery.requestCode == requestCode) return delivery;
      }
      return null;
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> confirmDelivery({
    required int partnerId,
    required int deliveryId,
    required ConfirmDeliveryRequest request,
  }) {
    return asyncGuard(() async {
      final response = await remote.confirmDelivery(
        partnerId: partnerId,
        deliveryId: deliveryId,
        body: request.toModel().toJson(),
      );
      final responseModel = DeliveryResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }
}
