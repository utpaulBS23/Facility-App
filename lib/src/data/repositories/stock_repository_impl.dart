import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../domain/entities/stock/facility_stock_balance_filter.dart';
import '../../domain/entities/stock/facility_stock_target_detail_entity.dart';
import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../domain/entities/stock/stock_averaging_filter.dart';
import '../../domain/entities/stock/stock_averaging_page_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import '../extension/facility_stock_balance_mapper.dart';
import '../extension/facility_stock_target_mapper.dart';
import '../extension/stock_count_mapper.dart';
import '../models/stock/facility_stock_balance_model.dart';
import '../models/stock/facility_stock_target_detail_model.dart';
import '../models/stock/facility_stock_target_model.dart';
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
  Future<Result<List<FacilityStockBalanceEntity>, Failure>>
      getFacilityStockBalance(FacilityStockBalanceFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getFacilityStockBalance(
        partnerId: filter.partnerId ?? 0,
        facilityId: filter.facilityId,
        stockItemId: filter.stockItemId,
        status: filter.status,
        page: filter.page,
        perPage: filter.perPage,
      );
      final responseModel =
          FacilityStockBalanceListResponseModel.fromJson(response.data);

      return responseModel.toEntityList();
    });
  }

  @override
  Future<Result<StockAveragingPageEntity, Failure>> getStockAveraging(
    StockAveragingFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getStockAveraging(
        partnerId: filter.partnerId ?? 0,
        facilityId: filter.facilityId,
        page: filter.page,
        perPage: filter.perPage,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final itemsRaw = data['items'] as List<dynamic>? ?? const [];
      final topItemsRaw = data['top_demand_items'] as List<dynamic>? ?? const [];

      final items = itemsRaw
          .map(
            (e) => FacilityStockTargetModel.fromJson(
              e as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      final topDemandItems = topItemsRaw
          .map(
            (e) => TopDemandItemModel.fromJson(
              e as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();

      return StockAveragingPageEntity(
        items: items,
        topDemandItems: topDemandItems,
      );
    });
  }

  @override
  Future<Result<FacilityStockTargetDetailEntity, Failure>>
      getFacilityStockTargets({
    required int partnerId,
    required int facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityStockTargets(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final responseModel = FacilityStockTargetDetailModel.fromJson(data);

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<FacilityStockTargetEntity, Failure>> updateStockTarget({
    required int partnerId,
    required int targetId,
    required double monthlyTargetQty,
  }) {
    return asyncGuard(() async {
      final response = await remote.updateStockTarget(
        partnerId: partnerId,
        targetId: targetId,
        body: {'monthly_target_qty': monthlyTargetQty},
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final responseModel = FacilityStockTargetModel.fromJson(data);

      return responseModel.toEntity();
    });
  }
}
