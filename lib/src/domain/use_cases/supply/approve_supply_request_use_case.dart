import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/supply_repository.dart';
import '../partner_use_case.dart';

final class ApproveSupplyRequestUseCase extends PartnerUseCase {
  ApproveSupplyRequestUseCase({
    required this.supplyRepository,
    required super.authRepository,
  });

  final SupplyRepository supplyRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    int supplyRequestId, {
    String? notes,
  }) async {
    return withPartnerId((partnerId) async {
      final result = await supplyRepository.approveSupplyRequest(
        partnerId,
        supplyRequestId,
        notes: notes,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('approve supply request')),
      };
    });
  }
}
