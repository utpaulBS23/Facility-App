import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/my_attendance_entity.dart';
import '../entities/supervisor_attendance_detail_entity.dart';
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
      // WHY the max page: one person has at most a month of rows here, and
      // this screen has no load-more, so the server default of 20 would cut
      // the month short.
      perPage: 100,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}

/// Supervisors' attendance across the caller's scope — the view an ops
/// manager gets of the supervisors beneath them.
final class GetSupervisorsAttendanceUseCase {
  GetSupervisorsAttendanceUseCase(this._repository, this._authRepository);

  final MyAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  // WHY no user id: unlike [GetMyAttendanceUseCase], this is not scoped to
  // the logged-in user — the server scopes the list by the caller's role.
  Future<Result<MyAttendanceOverviewEntity, Failure>> call({
    required String fromDay,
    required String toDay,
    int? facilityId,
    int? page,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getMyAttendance(
      partnerId: partnerId,
      fromDay: fromDay,
      toDay: toDay,
      facilityId: facilityId,
      page: page,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}

/// One supervisor's visits for one day, behind a supervisor-attendance row.
final class GetSupervisorAttendanceDetailsUseCase {
  GetSupervisorAttendanceDetailsUseCase(this._repository, this._authRepository);

  final MyAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<SupervisorAttendanceDetailEntity, Failure>> call({
    required int userId,
    required String date,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getSupervisorAttendanceDetails(
      partnerId: partnerId,
      userId: userId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
