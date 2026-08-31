import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/my_attendance_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/my_attendance_repository.dart';

final class GetMyAttendanceUseCase {
  GetMyAttendanceUseCase(this._repository, this._authRepository);

  final MyAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  // WHY: "my attendance" always scopes to the logged-in user — userId is
  // resolved here rather than accepted as a param, so callers can't
  // accidentally query someone else's history.
  Future<Result<MyAttendanceOverviewEntity, Failure>> call({
    required String fromDay,
    required String toDay,
    int? facilityId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final userId = _authRepository.getCurrentUser()?.id;
    if (userId == null) {
      return Error(Failure.emptyResponse('resolve current user'));
    }

    final result = await _repository.getMyAttendance(
      partnerId: partnerId,
      fromDay: fromDay,
      toDay: toDay,
      facilityId: facilityId,
      userId: userId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
