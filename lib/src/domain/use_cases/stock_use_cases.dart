import '../../core/base/base.dart';
import '../entities/stock/facility_stock_target_entity.dart';
import '../entities/stock/shift_stock_count_entity.dart';
import '../entities/stock/submit_stock_count_request.dart';
import '../repositories/stock_repository.dart';
import 'partner_use_case.dart';

final class GetFacilityStockTargetsUseCase extends PartnerUseCase {
  GetFacilityStockTargetsUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<FacilityStockTargetEntity>, Failure>> call({
    int? facilityId,
  }) {
    return withPartnerId((partnerId) async {
      final result = await stockRepository.getFacilityStockTargets(
        partnerId,
        facilityId: facilityId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load facility stock targets')),
      };
    });
  }
}

final class GetShiftStockCountsUseCase extends PartnerUseCase {
  GetShiftStockCountsUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<ShiftStockCountEntity>, Failure>> call({
    int? facilityId,
  }) {
    return withPartnerId((partnerId) async {
      final result = await stockRepository.getShiftStockCounts(
        partnerId,
        facilityId: facilityId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load shift stock counts')),
      };
    });
  }
}

final class SubmitShiftStockCountUseCase extends PartnerUseCase {
  SubmitShiftStockCountUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<ShiftStockCountEntity>, Failure>> call({
    required int shiftAssignmentId,
    required SubmitStockCountRequest request,
  }) {
    return withPartnerId((partnerId) async {
      final result = await stockRepository.submitShiftStockCount(
        partnerId,
        shiftAssignmentId,
        request,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('submit shift stock count')),
      };
    });
  }
}
