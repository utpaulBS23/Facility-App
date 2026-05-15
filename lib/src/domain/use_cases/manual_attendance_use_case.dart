import '../../core/base/result.dart';
import '../entities/manual_attendance_entity.dart';
import '../repositories/manual_attendance_repository.dart';

final class SubmitManualAttendanceUseCase {
  SubmitManualAttendanceUseCase(this._repository);

  final ManualAttendanceRepository _repository;

  Future<Result<ManualAttendanceResponseEntity, String>> call({
    required int partnerId,
    required ManualAttendanceRequestEntity request,
  }) async {
    final result = await _repository.submitManualAttendance(
      partnerId: partnerId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class RefreshAttendanceUseCase {
  RefreshAttendanceUseCase(this._repository);

  final ManualAttendanceRepository _repository;

  Future<Result<ManualAttendanceResponseEntity, String>> call({
    required int partnerId,
    required int shiftId,
  }) async {
    final result = await _repository.refreshAttendance(
      partnerId: partnerId,
      shiftId: shiftId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class WithdrawAttendanceUseCase {
  WithdrawAttendanceUseCase(this._repository);

  final ManualAttendanceRepository _repository;

  Future<Result<bool, String>> call({
    required int partnerId,
    required int attendanceId,
  }) async {
    final result = await _repository.withdrawAttendance(
      partnerId: partnerId,
      attendanceId: attendanceId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}
