import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetDeliveriesUseCase extends PartnerUseCase {
  GetDeliveriesUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> call([
    DeliveryFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getDeliveries(
      (filter ?? const DeliveryFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get deliveries')),
    };
  }
}
