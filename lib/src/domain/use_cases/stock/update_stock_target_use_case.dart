import '../../../core/base/base.dart';
import '../../entities/stock/facility_stock_target_entity.dart';
import '../../repositories/stock_repository.dart';
import '../partner_use_case.dart';

final class UpdateStockTargetUseCase extends PartnerUseCase {
  UpdateStockTargetUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<FacilityStockTargetEntity, Failure>> call({
    required int targetId,
    required double monthlyTargetQty,
  }) async {
    final partnerId = getPartnerId();
    final result = await stockRepository.updateStockTarget(
      partnerId: partnerId,
      targetId: targetId,
      monthlyTargetQty: monthlyTargetQty,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('update stock target')),
    };
  }
}
