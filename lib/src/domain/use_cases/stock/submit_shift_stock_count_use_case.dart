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
    required List<SubmitStockCountItemParams> items,
  }) async {
    return withPartnerId((partnerId) async {
      return stockRepository.submitShiftStockCount(
        partnerId: partnerId,
        shiftAssignmentId: shiftAssignmentId,
        items: items,
      );
    });
  }
}
