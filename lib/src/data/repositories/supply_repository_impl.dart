import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/repositories/supply_repository.dart';
import '../extension/supply_request_mapper.dart';
import '../models/supply/supply_response_models.dart';
import '../services/network/rest_client.dart';

final class SupplyRepositoryImpl extends Repository<dynamic>
    implements SupplyRepository {
  SupplyRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>> getSupplyRequests({
    required int partnerId,
    int? facilityId,
    String? status,
    String? urgency,
    String? search,
    int? page,
    int? perPage,
  }) {
    return asyncGuard(() async {
      final response = await remote.getSupplyRequests(
        partnerId: partnerId,
        facilityId: facilityId,
        status: status,
        urgency: urgency,
        search: search,
        page: page,
        perPage: perPage,
      );
      final responseModel =
          SupplyRequestListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }
}
