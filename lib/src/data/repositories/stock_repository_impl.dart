import '../../core/base/base.dart';
import '../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../domain/entities/stock/submit_stock_count_request.dart';
import '../../domain/repositories/stock_repository.dart';
import '../extension/stock_mapper.dart';
import '../models/stock/stock_response_models.dart';
import '../services/network/rest_client.dart';

final class StockRepositoryImpl extends StockRepository {
  StockRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<FacilityStockTargetEntity>, Failure>>
  getFacilityStockTargets(int partnerId, {int? facilityId}) {
    return asyncGuard(() async {
      final response = await remote.getFacilityStockTargets(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      final responseModel = FacilityStockTargetListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<ShiftStockCountEntity>, Failure>> getShiftStockCounts(
    int partnerId, {
    int? facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getShiftStockCounts(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      final responseModel = ShiftStockCountListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<ShiftStockCountEntity>, Failure>> submitShiftStockCount(
    int partnerId,
    int shiftAssignmentId,
    SubmitStockCountRequest request,
  ) {
    return asyncGuard(() async {
      final response = await remote.submitShiftStockCount(
        partnerId: partnerId,
        shiftAssignmentId: shiftAssignmentId,
        body: request.toModel().toJson(),
      );
      final responseModel = ShiftStockCountListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }
}
