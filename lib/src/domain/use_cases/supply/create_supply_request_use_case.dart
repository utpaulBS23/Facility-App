import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/supply_request_entity.dart';
import '../../entities/supply/supply_request_status.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/supply_repository.dart';

final class CreateSupplyRequestUseCase {
  CreateSupplyRequestUseCase(this._repository, this._authRepository);

  final SupplyRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<SupplyRequestEntity, Failure>> call({
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<CreateSupplyRequestItemParams> items,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await _repository.createSupplyRequest(
      partnerId: partnerId,
      facilityId: facilityId,
      urgency: urgency,
      notes: notes,
      items: items,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
