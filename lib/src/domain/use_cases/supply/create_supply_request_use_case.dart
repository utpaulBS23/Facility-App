import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_payloads.dart';
import '../../repositories/supply_repository.dart';

final class CreateSupplyRequestUseCase {
  CreateSupplyRequestUseCase({
    required this.supplyRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    CreateSupplyRequestEntity request,
  ) async {
    final result = await supplyRepository.createSupplyRequest(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create supply request')),
    };
  }
}
