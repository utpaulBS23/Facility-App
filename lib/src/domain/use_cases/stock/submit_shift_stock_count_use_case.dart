import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/stock/shift_stock_count_entity.dart';
import '../../repositories/stock_repository.dart';
import '../partner_use_case.dart';

final class SubmitShiftStockCountUseCase extends PartnerUseCase {
  SubmitShiftStockCountUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<ShiftStockCountEntity>, Failure>> call({
    required int shiftAssignmentId,
    required List<SubmitStockCountItemEntity> items,
  }) async {
    final partnerId = getPartnerId();
    final result = await stockRepository.submitShiftStockCount(
      partnerId: partnerId,
      shiftAssignmentId: shiftAssignmentId,
      items: items,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit shift stock count')),
    };
  }
}
