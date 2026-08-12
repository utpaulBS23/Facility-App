import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class RejectSupplyRequestUseCase extends PartnerUseCase {
  RejectSupplyRequestUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    int supplyRequestId, {
    String? notes,
  }) async {
    final partnerId = getPartnerId();
    final result = await supplyRepository.rejectSupplyRequest(
      partnerId,
      supplyRequestId,
      notes: notes,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('reject supply request')),
    };
  }
}
