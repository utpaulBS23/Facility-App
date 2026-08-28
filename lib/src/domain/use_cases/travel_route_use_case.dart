import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/travel_route_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/travel_route_repository.dart';

final class TravelRouteCheckInUseCase {
  TravelRouteCheckInUseCase(this._repository, this._authRepository);

  final TravelRouteRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TravelRouteCheckInEntity, Failure>> call({
    required TravelRouteCheckInRequestEntity request,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.checkIn(
      partnerId: partnerId,
      request: request,
    );
    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('travel route check-in')),
    };
  }
}
