import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../domain/entities/stock/facility_stock_balance_filter.dart';
import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import '../extension/facility_stock_balance_mapper.dart';
import '../extension/stock_count_mapper.dart';
import '../models/stock/facility_stock_balance_model.dart';
import '../models/stock/shift_stock_count_response_models.dart';
import '../services/network/rest_client.dart';

final class StockRepositoryImpl extends StockRepository {
  StockRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<List<ShiftStockCountEntity>, Failure>> submitShiftStockCount({
    required int partnerId,
    required int shiftAssignmentId,
    required List<SubmitStockCountItemEntity> items,
  }) {
    return asyncGuard(() async {
      final response = await remote.submitShiftStockCount(
        partnerId: partnerId,
        shiftAssignmentId: shiftAssignmentId,
        body: items.toRequestModel().toJson(),
      );
      final responseModel =
          ShiftStockCountListResponseModel.fromJson(response.data);

      return responseModel.toEntityList();
    });
  }

  @override
  Future<Result<List<ShiftStockCountEntity>, Failure>> getShiftStockCounts({
    required int partnerId,
    int? facilityId,
    int? shiftAssignmentId,
    int? stockItemId,
    String? from,
    String? to,
  }) {
    return asyncGuard(() async {
      final response = await remote.getShiftStockCounts(
        partnerId: partnerId,
        facilityId: facilityId,
        shiftAssignmentId: shiftAssignmentId,
        stockItemId: stockItemId,
        from: from,
        to: to,
      );


      final responseModel =
          ShiftStockCountListResponseModel.fromJson(response.data);

      return responseModel.toEntityList();
    });
  }

  @override
  Future<Result<FacilityStockBalancePageEntity, Failure>>
      getFacilityStockBalance(FacilityStockBalanceFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getFacilityStockBalance(
        partnerId: filter.partnerId ?? 0,
        facilityId: filter.facilityId,
        status: filter.status,
        page: filter.page,
        perPage: filter.perPage,
      );
      final responseModel =
          FacilityStockBalanceListResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }
}
