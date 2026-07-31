import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/supply_repository.dart';

final class RejectSupplyRequestUseCase {
  RejectSupplyRequestUseCase(this._repository, this._authRepository);

  final SupplyRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<SupplyRequestEntity, Failure>> call(
    int supplyRequestId, {
    String? notes,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await _repository.rejectSupplyRequest(
      partnerId,
      supplyRequestId,
      notes: notes,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
