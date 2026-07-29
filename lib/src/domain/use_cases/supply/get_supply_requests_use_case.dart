import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/supply_repository.dart';

final class GetSupplyRequestsUseCase {
  GetSupplyRequestsUseCase(this._repository);
  final SupplyRepository _repository;

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> call({
    required int partnerId,
    int? facilityId,
    String? status,
    String? urgency,
    String? search,
    int? page,
    int? perPage,
  }) async {
    final result = await _repository.getSupplyRequests(
      partnerId: partnerId,
      facilityId: facilityId,
      status: status,
      urgency: urgency,
      search: search,
      page: page,
      perPage: perPage,
    );
    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
