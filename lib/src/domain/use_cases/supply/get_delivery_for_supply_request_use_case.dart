import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/delivery_repository.dart';
import '../partner_use_case.dart';

final class GetDeliveryForSupplyRequestUseCase extends PartnerUseCase {
  GetDeliveryForSupplyRequestUseCase({
    required this.deliveryRepository,
    required super.authRepository,
  });

  final DeliveryRepository deliveryRepository;

  Future<Result<DeliveryEntity?, Failure>> call({
    required String requestCode,
  }) async {
    return withPartnerId((partnerId) async {
      return deliveryRepository.getDeliveryForSupplyRequest(
        partnerId: partnerId,
        requestCode: requestCode,
      );
    });
  }
}
