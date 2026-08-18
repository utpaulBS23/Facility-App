import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/stock_allocation_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetStockAllocationDetailsUseCase extends PartnerUseCase {
  GetStockAllocationDetailsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<StockAllocationEntity, Failure>> call(
    int stockAllocationId,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getStockAllocationDetails(
      partnerId: partnerId,
      stockAllocationId: stockAllocationId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get stock allocation details')),
    };
  }
}
