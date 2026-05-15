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
