import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../entities/shift_entity.dart';
import '../entities/shift_slot_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/shift_repository.dart';

/// Shown when a session is entitled to neither shift experience.
const String shiftsUnavailableMessage =
    'Shifts are not available for your account.';

/// Shown when the session carries no facility to scope the slot query to.
const String noAccessibleFacilityMessage =
    'No facility is available for your account.';

final class GetShiftSlotsUseCase {
  GetShiftSlotsUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<ShiftSlotsEntity, String>> call({
    required int partnerId,
    required String date,
    int? facilityId,
  }) async {
    final session = _authRepository.currentSession;

    if ((session?.shiftViewMode ?? ShiftViewMode.unavailable) ==
        ShiftViewMode.unavailable) {
      return const Error(shiftsUnavailableMessage);
    }

    // WHY: the endpoint is facility-scoped but the app has no facility picker
    // yet, so it defaults to the session's primary facility (falling back to
    // the first accessible one). An explicit [facilityId] wins, which is the
    // seam a future picker plugs into.
    final resolvedFacilityId =
        facilityId ?? _primaryFacilityId(session?.accessibleFacilities);
    if (resolvedFacilityId == null) {
      return const Error(noAccessibleFacilityMessage);
    }

    final result = await _shiftRepository.getShiftSlots(
      partnerId: partnerId,
      facilityId: resolvedFacilityId,
      date: date,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to get shift slots'),
    };
  }

  int? _primaryFacilityId(List<AccessibleFacilityEntity>? facilities) {
    if (facilities == null || facilities.isEmpty) return null;
    for (final facility in facilities) {
      if (facility.isPrimary) return facility.id;
    }
    return facilities.first.id;
  }
}

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

final class AssignShiftSlotUseCase {
  AssignShiftSlotUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, String>> call({
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');

    final result = await _shiftRepository.assignShiftSlot(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
      shiftSlotId: shiftSlotId,
      attendantId: attendantId,
      isSlotLead: isSlotLead,
    );

    return switch (result) {
      Success() => const Success(),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to assign staff'),
    };
  }
}

final class CreateRosterUseCase {
  CreateRosterUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<RosterEntity, String>> call({
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');

    final result = await _shiftRepository.createRoster(
      partnerId: partnerId,
      facilityId: facilityId,
      weekStartDate: weekStartDate,
      weekEndDate: weekEndDate,
      offDays: offDays,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to create roster'),
    };
  }
}

final class CreateShiftUseCase {
  CreateShiftUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<ShiftEntity, String>> call({
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');

    final result = await _shiftRepository.createShift(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
      shiftTemplateId: shiftTemplateId,
      shiftDate: shiftDate,
      notes: notes,
      minAttendants: minAttendants,
      maxAttendants: maxAttendants,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to create shift'),
    };
  }
}
