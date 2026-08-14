import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/supply_filters.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/supply_repository.dart';

final class GetSupplyRequestsUseCase {
  GetSupplyRequestsUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> call(
    SupplyRequestQueryFilter filter,
  ) async {
    final result = await supplyRepository.getSupplyRequests(filter);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get supply requests')),
    };
  }
}
