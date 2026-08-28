import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/stock/shift_stock_count_entity.dart';
import '../../repositories/stock_repository.dart';
import '../partner_use_case.dart';

final class GetShiftStockCountsUseCase extends PartnerUseCase {
  GetShiftStockCountsUseCase({
    required this.stockRepository,
    required super.authRepository,
  });

  final StockRepository stockRepository;

  Future<Result<List<ShiftStockCountEntity>, Failure>> call({
    int? facilityId,
    int? shiftAssignmentId,
    int? stockItemId,
    String? from,
    String? to,
  }) async {
    return withPartnerId((partnerId) async {
      return stockRepository.getShiftStockCounts(
        partnerId: partnerId,
        facilityId: facilityId,
        shiftAssignmentId: shiftAssignmentId,
        stockItemId: stockItemId,
        from: from,
        to: to,
      );
    });
  }
}
