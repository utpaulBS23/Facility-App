import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetDeliveryDetailsUseCase extends PartnerUseCase {
  GetDeliveryDetailsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryEntity, Failure>> call(int deliveryId) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getDeliveryDetails(
      partnerId,
      deliveryId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get delivery details')),
    };
  }
}
