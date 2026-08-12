import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_status.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetSupplyRequestsUseCase extends PartnerUseCase {
  GetSupplyRequestsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> call({
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getSupplyRequests(
      partnerId: partnerId,
      facilityId: facilityId,
      status: status,
      urgency: urgency,
      search: search,
      page: page,
      pageSize: pageSize,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get supply requests')),
    };
  }
}
