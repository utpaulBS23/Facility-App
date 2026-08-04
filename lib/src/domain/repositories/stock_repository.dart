import '../../core/base/base.dart';
import '../entities/stock/facility_stock_target_entity.dart';
import '../entities/stock/shift_stock_count_entity.dart';
import '../entities/stock/submit_stock_count_request.dart';

abstract base class StockRepository extends Repository {
  Future<Result<List<FacilityStockTargetEntity>, Failure>>
  getFacilityStockTargets(int partnerId, {int? facilityId});

  Future<Result<List<ShiftStockCountEntity>, Failure>> getShiftStockCounts(
    int partnerId, {
    int? facilityId,
  });

  Future<Result<List<ShiftStockCountEntity>, Failure>> submitShiftStockCount(
    int partnerId,
    int shiftAssignmentId,
    SubmitStockCountRequest request,
  );
}
