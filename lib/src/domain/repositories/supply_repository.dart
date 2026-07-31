import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/supply_request_entity.dart';
import '../entities/supply/supply_request_status.dart';

abstract base class SupplyRepository extends Repository {
  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
      getSupplyRequests({
    required int partnerId,
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  });
}
