import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/check_out_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/check_out_repository.dart';

final class CheckOutUseCase {
  CheckOutUseCase(this.repository, this._authRepository);

  final CheckOutRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<CheckOutEntity, Failure>> call({
    required int attendanceId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? reason,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await repository.checkOut(
      partnerId: partnerId,
      attendanceId: attendanceId,
      lat: lat,
      lng: lng,
      selfieUrl: selfieUrl,
      reason: reason,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
