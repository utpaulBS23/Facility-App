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
    final partnerId = getPartnerId();
    final result = await stockRepository.getShiftStockCounts(
      partnerId: partnerId,
      facilityId: facilityId,
      shiftAssignmentId: shiftAssignmentId,
      stockItemId: stockItemId,
      from: from,
      to: to,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get shift stock counts')),
    };
  }
}
