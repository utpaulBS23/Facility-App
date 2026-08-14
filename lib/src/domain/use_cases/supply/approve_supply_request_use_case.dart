import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';

final class ApproveSupplyRequestUseCase {
  ApproveSupplyRequestUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    ApproveSupplyRequestEntity request,
  ) async {
    final result = await supplyRepository.approveSupplyRequest(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('approve supply request')),
    };
  }
}
