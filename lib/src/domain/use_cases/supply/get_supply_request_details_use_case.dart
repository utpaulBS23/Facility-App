import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class GetSupplyRequestDetailsUseCase extends PartnerUseCase {
  GetSupplyRequestDetailsUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    int supplyRequestId,
  ) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.getSupplyRequestDetails(
      partnerId,
      supplyRequestId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get supply request details')),
    };
  }
}
