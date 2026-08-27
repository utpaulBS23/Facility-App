import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/authentication_repository.dart';

final class GetMonthlyAttendanceOverviewUseCase {
  GetMonthlyAttendanceOverviewUseCase(this._repository, this._authRepository);

  final AttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<MonthlyAttendanceSummaryEntity, Failure>> call({
    required String month,
    int? facilityId,
    int? userId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getMonthlyAttendanceOverview(
      partnerId: partnerId,
      month: month,
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

final class ApproveAttendanceUseCase {
  ApproveAttendanceUseCase(this._repository, this._authRepository);

  final AttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<AttendanceItemEntity, Failure>> call({
    required int attendanceId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.approveAttendance(
      partnerId: partnerId,
      attendanceId: attendanceId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}

final class RejectAttendanceUseCase {
  RejectAttendanceUseCase(this._repository, this._authRepository);

  final AttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<AttendanceItemEntity, Failure>> call({
    required int attendanceId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.rejectAttendance(
      partnerId: partnerId,
      attendanceId: attendanceId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}
