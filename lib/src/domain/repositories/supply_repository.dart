import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/stock/facility_stock_balance_entity.dart';
import '../entities/stock/facility_stock_balance_filter.dart';
import '../entities/stock/facility_stock_target_detail_entity.dart';
import '../entities/stock/facility_stock_target_entity.dart';
import '../entities/stock/stock_averaging_filter.dart';
import '../entities/stock/stock_averaging_page_entity.dart';
import '../entities/supply/supply_request_entity.dart';
import '../entities/supply/supply_request_status.dart';

class CreateSupplyRequestItemParams {
  const CreateSupplyRequestItemParams({
    required this.stockItemId,
    required this.qtyRequested,
    this.unitPrice,
  });

  final int stockItemId;
  final double qtyRequested;
  final double? unitPrice;
}

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

  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest({
    required int partnerId,
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<CreateSupplyRequestItemParams> items,
  });

  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
  });

  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
  });

  Future<Result<FacilityStockBalancePageEntity, Failure>>
      getFacilityStockBalance(
    FacilityStockBalanceFilter filter,
  );

  Future<Result<StockAveragingPageEntity, Failure>> getStockAveraging(
    StockAveragingFilter filter,
  );

  Future<Result<FacilityStockTargetDetailEntity, Failure>>
      getFacilityStockTargets({
    required int partnerId,
    required int facilityId,
  });

  Future<Result<FacilityStockTargetEntity, Failure>> updateStockTarget({
    required int partnerId,
    required int targetId,
    required double monthlyTargetQty,
  });
}
