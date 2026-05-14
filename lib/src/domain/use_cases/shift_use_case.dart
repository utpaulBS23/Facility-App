import '../../core/base/result.dart';
import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

final class GetMyShiftsUseCase {
  GetMyShiftsUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Result<List<ShiftEntity>, String>> call({
    required int partnerId,
    required String date,
  }) async {
    final result = await _repository.getMyShifts(
      partnerId: partnerId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get shifts'),
    };
  }
}

final class GetSupervisorShiftsUseCase {
  GetSupervisorShiftsUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Result<List<ShiftEntity>, String>> call({
    required int partnerId,
    required String date,
  }) async {
    final result = await _repository.getSupervisorShifts(
      partnerId: partnerId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get supervisor shifts'),
    };
  }
}
