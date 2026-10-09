import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../domain/entities/cash_collection/cash_collection_filter.dart';
import '../../domain/entities/cash_collection/cash_collection_payloads.dart';
import '../../domain/repositories/cash_collection_repository.dart';
import '../extension/cash_collection_mapper.dart';
import '../models/cash_collection/cash_collection_model.dart';
import '../services/network/rest_client.dart';

final class CashCollectionRepositoryImpl extends CashCollectionRepository {
  CashCollectionRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<CashCollectionListResultEntity, Failure>> getCashCollections(
    CashCollectionFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getCashCollections(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        month: filter.month,
        page: filter.page,
        perPage: filter.pageSize,
      );

      return CashCollectionListResponseModel.fromJson(response.data).toEntity();
    });
  }

  @override
  Future<Result<CashCollectionEntity, Failure>> createCashCollection(
    CreateCashCollectionRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createCashCollection(
        partnerId: request.partnerId!,
        formData: await request.toFormData(),
      );

      return CashCollectionResponseModel.fromJson(
        response.data,
      ).data!.toEntity();
    });
  }

  @override
  Future<Result<List<FacilityServiceEntity>, Failure>> getFacilityServices({
    required int partnerId,
    required int facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityServices(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      // WHY a bare list: this endpoint is not wrapped in `{data: ...}`.
      final rows = response.data as List;

      return rows
          .map(
            (row) => FacilityServiceModel.fromJson(
              Map<String, dynamic>.from(row as Map),
            ).toEntity(),
          )
          .toList();
    });
  }
}
