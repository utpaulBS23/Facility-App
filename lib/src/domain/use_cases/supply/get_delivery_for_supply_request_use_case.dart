import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetDeliveryForSupplyRequestUseCase extends PartnerUseCase {
  GetDeliveryForSupplyRequestUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<DeliveryEntity?, Failure>> call({
    required String requestCode,
  }) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getDeliveries(
      DeliveryFilter(partnerId: partnerId, search: requestCode),
    );

    return switch (result) {
      Success(:final data) => Success(data: data?.items.firstOrNull),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get delivery for supply request')),
    };
  }
}
