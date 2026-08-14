import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/delivery_repository.dart';
import '../partner_use_case.dart';

final class DispatchSupplyRequestUseCase extends PartnerUseCase {
  DispatchSupplyRequestUseCase({
    required this.deliveryRepository,
    required super.authRepository,
  });

  final DeliveryRepository deliveryRepository;

  Future<Result<DeliveryEntity, Failure>> call(
    int supplyRequestId,
  ) async {
    return withPartnerId((partnerId) async {
      final result = await deliveryRepository.dispatchSupplyRequest(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('dispatch supply request')),
      };
    });
  }
}
