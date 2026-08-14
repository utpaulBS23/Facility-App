import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';

final class GetDeliveriesUseCase {
  GetDeliveriesUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> call(
    DeliveryFilter filter,
  ) async {
    final result = await supplyRepository.getDeliveries(filter);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get deliveries')),
    };
  }
}
