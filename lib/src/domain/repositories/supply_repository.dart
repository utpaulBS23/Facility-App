import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/supply_request_entity.dart';

abstract class SupplyRepository {
  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> getSupplyRequests({
    required int partnerId,
    int? facilityId,
    String? status,
    String? urgency,
    String? search,
    int? page,
    int? perPage,
  });
}
