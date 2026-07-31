import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_status.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/supply_repository.dart';

final class GetSupplyRequestsUseCase {
  GetSupplyRequestsUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final SupplyRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> call({
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getSupplyRequests(
      partnerId: partnerId,
      facilityId: facilityId,
      status: status,
      urgency: urgency,
      search: search,
      page: page,
      pageSize: pageSize,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
