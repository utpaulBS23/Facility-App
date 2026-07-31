import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/manual_attendance_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/manual_attendance_repository.dart';

final class SubmitManualAttendanceUseCase {
  SubmitManualAttendanceUseCase(this._repository, this._authRepository);

  final ManualAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<ManualAttendanceResponseEntity, Failure>> call({
    required ManualAttendanceRequestEntity request,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.submitManualAttendance(
      partnerId: partnerId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}

final class RefreshAttendanceUseCase {
  RefreshAttendanceUseCase(this._repository, this._authRepository);

  final ManualAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<ManualAttendanceResponseEntity, Failure>> call({
    required int shiftId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.refreshAttendance(
      partnerId: partnerId,
      shiftId: shiftId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete the request')),
    };
  }
}

final class WithdrawAttendanceUseCase {
  WithdrawAttendanceUseCase(this._repository, this._authRepository);

  final ManualAttendanceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<bool, Failure>> call({required int attendanceId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.withdrawAttendance(
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
