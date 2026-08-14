import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';

final class ConfirmDeliveryUseCase {
  ConfirmDeliveryUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryEntity, Failure>> call(
    ConfirmDeliveryRequestEntity request,
  ) async {
    final result = await supplyRepository.confirmDelivery(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('confirm delivery')),
    };
  }
}
