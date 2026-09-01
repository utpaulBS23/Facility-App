import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/location_ping_repository.dart';

final class StartLocationPingTrackingUseCase {
  StartLocationPingTrackingUseCase(this._repository);

  final LocationPingRepository _repository;

  Future<Result<void, Failure>> call({required int taskId}) {
    return _repository.startTracking(taskId: taskId);
  }
}

final class StopLocationPingTrackingUseCase {
  StopLocationPingTrackingUseCase(this._repository);

  final LocationPingRepository _repository;

  Future<Result<void, Failure>> call() {
    return _repository.stopTracking();
  }
}

/// One visit can be tracked at a time — [taskId] is null whenever
/// [isSharing] is false.
typedef LocationSharingStatus = ({bool isSharing, int? taskId});

final class GetLocationSharingStatusUseCase {
  GetLocationSharingStatusUseCase(this._repository);

  final LocationPingRepository _repository;

  LocationSharingStatus call() => (
    isSharing: _repository.isSharingLocation,
    taskId: _repository.activeTaskId,
  );
}

final class SyncCurrentLocationPingUseCase {
  SyncCurrentLocationPingUseCase(this._repository, this._authRepository);

  final LocationPingRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({required int taskId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.syncCurrentLocation(taskId: taskId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('sync current location ping')),
    };
  }
}
