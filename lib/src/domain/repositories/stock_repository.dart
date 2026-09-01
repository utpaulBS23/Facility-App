import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/stock/facility_stock_balance_entity.dart';
import '../entities/stock/facility_stock_balance_filter.dart';
import '../entities/stock/facility_stock_target_detail_entity.dart';
import '../entities/stock/facility_stock_target_entity.dart';
import '../entities/stock/shift_stock_count_entity.dart';
import '../entities/stock/stock_averaging_filter.dart';
import '../entities/stock/stock_averaging_overview_entity.dart';

abstract base class StockRepository extends Repository {
  Future<Result<List<ShiftStockCountEntity>, Failure>> submitShiftStockCount({
    required int partnerId,
    required int shiftAssignmentId,
    required List<SubmitStockCountItemEntity> items,
  });

  Future<Result<List<ShiftStockCountEntity>, Failure>> getShiftStockCounts({
    required int partnerId,
    int? facilityId,
    int? shiftAssignmentId,
    int? stockItemId,
    String? from,
    String? to,
  });

  Future<Result<List<FacilityStockBalanceEntity>, Failure>>
      getFacilityStockBalance(FacilityStockBalanceFilter filter);

  Future<Result<StockAveragingOverviewEntity, Failure>> getStockAveraging(
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
