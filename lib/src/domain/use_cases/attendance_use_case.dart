import '../../core/base/result.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

final class GetAttendanceSummaryUseCase {
  GetAttendanceSummaryUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Result<AttendanceSummaryEntity, String>> call() async {
    final result = await _repository.getAttendanceSummary();
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetAttendanceDetailUseCase {
  GetAttendanceDetailUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Result<AttendanceDetailEntity, String>> call(String id) async {
    final result = await _repository.getAttendanceDetail(id);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}
