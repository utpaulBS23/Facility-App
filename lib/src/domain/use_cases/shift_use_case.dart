import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/login_entity.dart';
import '../entities/shift_entity.dart';
import '../entities/shift_slot_entity.dart';
import '../entities/shift_template_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/shift_repository.dart';

final class GetShiftSlotsUseCase {
  GetShiftSlotsUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<ShiftSlotsEntity, Failure>> call({
    required String date,
    int? facilityId,
  }) async {
    final session = _authRepository.currentSession;

    final partnerId = session?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    if (!(session?.hasShiftAccess ?? false)) {
      return const Error(Failure.shiftsUnavailable);
    }

    // WHY: the endpoint is facility-scoped but the app has no facility picker
    // yet, so it defaults to the session's primary facility (falling back to
    // the first accessible one). An explicit [facilityId] wins, which is the
    // seam a future picker plugs into.
    final resolvedFacilityId =
        facilityId ?? _primaryFacilityId(session?.accessibleFacilities);
    if (resolvedFacilityId == null) {
      return const Error(Failure.noAccessibleFacility);
    }

    final result = await _shiftRepository.getShiftSlots(
      partnerId: partnerId,
      facilityId: resolvedFacilityId,
      date: date,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get shift slots')),
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

  Future<Result<List<ShiftEntity>, Failure>> call({
    required String date,
  }) async {
    final session = _authRepository.currentSession;

    final partnerId = session?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    // WHY: the endpoint follows the session's entitlement, not a proxy. A
    // session with neither permission is not silently sent to the supervisor
    // endpoint — it fails closed instead of issuing an unauthorised request.
    final entitlement = session?.shiftEntitlement ?? ShiftEntitlement.none;

    final result = switch (entitlement) {
      ShiftEntitlement.supervisor => await _shiftRepository.getSupervisorShifts(
        partnerId: partnerId,
        date: date,
      ),
      ShiftEntitlement.attendant => await _shiftRepository.getMyShifts(
        partnerId: partnerId,
        date: date,
      ),
      ShiftEntitlement.none => null,
    };

    if (result == null) return const Error(Failure.shiftsUnavailable);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get shifts')),
    };
  }
}

final class AssignShiftSlotUseCase {
  AssignShiftSlotUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

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
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('assign staff')),
    };
  }
}

final class UnassignShiftSlotUseCase {
  UnassignShiftSlotUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.unassignShiftSlot(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
      assignmentId: assignmentId,
    );

    return switch (result) {
      Success() => const Success(),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('unassign staff')),
    };
  }
}

final class MakeSlotLeadUseCase {
  MakeSlotLeadUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.makeSlotLead(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
      assignmentId: assignmentId,
    );

    return switch (result) {
      Success() => const Success(),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('make slot lead')),
    };
  }
}

final class CreateRosterUseCase {
  CreateRosterUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<RosterEntity, Failure>> call({
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.createRoster(
      partnerId: partnerId,
      facilityId: facilityId,
      weekStartDate: weekStartDate,
      weekEndDate: weekEndDate,
      offDays: offDays,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create roster')),
    };
  }
}

final class GetRostersUseCase {
  GetRostersUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<RosterListEntity, Failure>> call({
    required int facilityId,
    int? page,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.getRosters(
      partnerId: partnerId,
      facilityId: facilityId,
      page: page,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get rosters')),
    };
  }
}

final class PublishRosterUseCase {
  PublishRosterUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<RosterEntity, Failure>> call({
    required int facilityId,
    required int rosterId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.publishRoster(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('publish roster')),
    };
  }
}

final class GetRosterShiftsUseCase {
  GetRosterShiftsUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<RosterShiftsEntity, Failure>> call({
    required int facilityId,
    required int rosterId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.getRosterShifts(
      partnerId: partnerId,
      facilityId: facilityId,
      rosterId: rosterId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get roster shifts')),
    };
  }
}

final class GetShiftTemplatesUseCase {
  GetShiftTemplatesUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<ShiftTemplateEntity>, Failure>> call() async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _shiftRepository.getShiftTemplates(
      partnerId: partnerId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get shift templates')),
    };
  }
}

final class CreateShiftUseCase {
  CreateShiftUseCase(this._shiftRepository, this._authRepository);

  final ShiftRepository _shiftRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<ShiftEntity, Failure>> call({
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

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
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create shift')),
    };
  }
}
