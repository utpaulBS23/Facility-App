import '../../core/base/result.dart';
import '../entities/shift_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/shift_repository.dart';

final class GetShiftsUseCase {
  GetShiftsUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<ShiftEntity>, String>> call({
    required int partnerId,
    required String date,
  }) async {
    // WHY: user_role no longer exists — shift-attendant capability decides
    // whether we fetch own shifts or facility-wide supervisor shifts.
    final isAttendant =
        _authRepository.currentSession?.isShiftAttendant ?? true;
    final result = isAttendant
        ? await _shiftRepository.getMyShifts(partnerId: partnerId, date: date)
        : await _shiftRepository.getSupervisorShifts(
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
