import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/confirm_delivery_request.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/delivery_repository.dart';
import '../partner_use_case.dart';

/// Confirms delivery receipt for a supply request.
///
/// WHY: Accepts [ConfirmDeliveryRequest] write payload rather than [DeliveryEntity]
/// to keep write parameters decoupled from read models.
final class ConfirmDeliveryUseCase extends PartnerUseCase {
  ConfirmDeliveryUseCase({
    required this.deliveryRepository,
    required super.authRepository,
  });

  final DeliveryRepository deliveryRepository;

  Future<Result<DeliveryEntity, Failure>> call({
    required int deliveryId,
    required ConfirmDeliveryRequest request,
  }) async {
    return withPartnerId((partnerId) async {
      return deliveryRepository.confirmDelivery(
        partnerId: partnerId,
        deliveryId: deliveryId,
        request: request,
      );
    });
  }
}
