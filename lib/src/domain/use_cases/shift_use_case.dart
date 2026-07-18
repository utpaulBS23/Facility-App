import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../entities/shift_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/shift_repository.dart';

/// Shown when a session is entitled to neither shift experience.
const String shiftsUnavailableMessage =
    'Shifts are not available for your account.';

final class GetShiftsUseCase {
  GetShiftsUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<ShiftEntity>, String>> call({
    required int partnerId,
    required String date,
  }) async {
    // WHY: the endpoint follows the session's entitlement, not a proxy. A
    // session with neither permission is not silently sent to the supervisor
    // endpoint — it fails closed instead of issuing an unauthorised request.
    final mode =
        _authRepository.currentSession?.shiftViewMode ??
        ShiftViewMode.unavailable;

    final result = switch (mode) {
      ShiftViewMode.supervisor => await _shiftRepository.getSupervisorShifts(
        partnerId: partnerId,
        date: date,
      ),
      ShiftViewMode.attendant => await _shiftRepository.getMyShifts(
        partnerId: partnerId,
        date: date,
      ),
      ShiftViewMode.unavailable => null,
    };

    if (result == null) return const Error(shiftsUnavailableMessage);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get shifts'),
    };
  }
}
