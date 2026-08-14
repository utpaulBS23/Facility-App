import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class ConfirmDeliveryUseCase extends PartnerUseCase {
  ConfirmDeliveryUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryEntity, Failure>> call(
    ConfirmDeliveryRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.confirmDelivery(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('confirm delivery')),
    };
  }
}
