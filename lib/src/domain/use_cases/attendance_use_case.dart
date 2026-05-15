import '../../core/base/result.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

final class GetMonthlyAttendanceOverviewUseCase {
  GetMonthlyAttendanceOverviewUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Result<MonthlyAttendanceSummaryEntity, String>> call({
    required int partnerId,
    required String month,
  }) async {
    final result = await _repository.getMonthlyAttendanceOverview(
      partnerId: partnerId,
      month: month,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class ApproveAttendanceUseCase {
  ApproveAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Result<AttendanceItemEntity, String>> call({
    required int partnerId,
    required int attendanceId,
  }) async {
    final result = await _repository.approveAttendance(
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

final class RejectAttendanceUseCase {
  RejectAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Result<AttendanceItemEntity, String>> call({
    required int partnerId,
    required int attendanceId,
  }) async {
    final result = await _repository.rejectAttendance(
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
