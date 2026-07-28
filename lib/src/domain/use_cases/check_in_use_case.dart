import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/check_in_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/check_in_repository.dart';

final class CheckInUseCase {
  CheckInUseCase(this.repository, this._authRepository);

  final CheckInRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<CheckInEntity, Failure>> call({
    required int shiftSlotId,
    required double lat,
    required double lng,
    required String selfieUrl,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await repository.checkIn(
      partnerId: partnerId,
      shiftSlotId: shiftSlotId,
      lat: lat,
      lng: lng,
      selfieUrl: selfieUrl,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
