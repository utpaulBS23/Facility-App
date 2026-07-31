import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/supply/delivery_entity.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/delivery_repository.dart';

final class ConfirmDeliveryUseCase {
  ConfirmDeliveryUseCase(this._repository, this._authRepository);

  final DeliveryRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<DeliveryEntity, Failure>> call({
    required int deliveryId,
    String? receiptPhotoUrl,
    String? deliveryNotes,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    return _repository.confirmDelivery(
      partnerId: partnerId,
      deliveryId: deliveryId,
      receiptPhotoUrl: receiptPhotoUrl,
      deliveryNotes: deliveryNotes,
    );
  }
}
