import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/delivery_repository.dart';

final class GetDeliveryForSupplyRequestUseCase {
  GetDeliveryForSupplyRequestUseCase(this._repository, this._authRepository);

  final DeliveryRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<DeliveryEntity?, Failure>> call({
    required String requestCode,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    return _repository.getDeliveryForSupplyRequest(
      partnerId: partnerId,
      requestCode: requestCode,
    );
  }
}
