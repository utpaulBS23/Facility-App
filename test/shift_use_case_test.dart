import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/shift_entity.dart';
import 'package:facility_management_app/src/domain/entities/shift_slot_entity.dart';
import 'package:facility_management_app/src/domain/entities/shift_template_entity.dart';
import 'package:facility_management_app/src/domain/entities/sign_up_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/shift_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/shift_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hand-written test double — this project has no mockito/mocktail
/// dependency (see pubspec.yaml), so existing tests (e.g.
/// session_teardown_test.dart) exercise real/fake implementations directly.
final class FakeAuthenticationRepository extends AuthenticationRepository {
  UserSessionEntity? session;

  @override
  UserSessionEntity? get currentSession => session;

  @override
  Result<int, Failure> requireActivePartnerId() {
    final partnerId = session?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);
    return Success(data: partnerId);
  }

  @override
  Future<SignUpResponseEntity> register(SignUpRequestEntity data) =>
      throw UnimplementedError();

  @override
  Future<Result<LoginResponseEntity, Failure>> login(LoginRequestEntity data) =>
      throw UnimplementedError();

  @override
  Future<String> forgotPassword(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<String> resetPassword(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<String> verifyOTP(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<String> resendOTP(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<void> logout() => throw UnimplementedError();

  @override
  UserEntity? getCurrentUser() => null;

  @override
  Stream<UserSessionEntity?> watchSession() => const Stream.empty();

  @override
  Set<UserPermission> getPermissions() => session?.permissions ?? const {};

  @override
  bool hasPermission(UserPermission permission) =>
      session?.can(permission) ?? false;

  @override
  List<AccessibleFacilityEntity> getAccessibleFacilities() =>
      session?.accessibleFacilities ?? const [];

  @override
  void dispose() {}
}

/// Stubs every method with an override slot the individual tests fill in; a
/// method that is not stubbed and gets called throws, which fails the test
/// loudly instead of returning a silently-wrong default.
final class FakeShiftRepository extends ShiftRepository {
  Future<Result<ShiftGlobalConfigEntity, Failure>> Function()?
  onGetShiftGlobalConfig;
  Future<Result<ShiftSlotsEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required String date,
  })?
  onGetShiftSlots;
  Future<Result<List<ShiftEntity>, Failure>> Function({
    required int partnerId,
    required String date,
  })?
  onGetMyShifts;
  Future<Result<List<ShiftEntity>, Failure>> Function({
    required int partnerId,
    required String date,
  })?
  onGetSupervisorShifts;
  Future<Result<void, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  })?
  onAssignShiftSlot;
  Future<Result<void, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  })?
  onUnassignShiftSlot;
  Future<Result<void, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  })?
  onMakeSlotLead;
  Future<Result<RosterEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  })?
  onCreateRoster;
  Future<Result<RosterListEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    int? page,
  })?
  onGetRosters;
  Future<Result<RosterEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  })?
  onPublishRoster;
  Future<Result<ShiftEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  })?
  onCreateShift;
  Future<Result<RosterShiftsEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  })?
  onGetRosterShifts;
  Future<Result<List<ShiftTemplateEntity>, Failure>> Function({
    required int partnerId,
  })?
  onGetShiftTemplates;

  @override
  Future<Result<ShiftGlobalConfigEntity, Failure>> getShiftGlobalConfig() =>
      onGetShiftGlobalConfig!();

  @override
  Future<Result<ShiftSlotsEntity, Failure>> getShiftSlots({
    required int partnerId,
    required int facilityId,
    required String date,
  }) => onGetShiftSlots!(
    partnerId: partnerId,
    facilityId: facilityId,
    date: date,
  );

  @override
  Future<Result<List<ShiftEntity>, Failure>> getMyShifts({
    required int partnerId,
    required String date,
  }) => onGetMyShifts!(partnerId: partnerId, date: date);

  @override
  Future<Result<List<ShiftEntity>, Failure>> getSupervisorShifts({
    required int partnerId,
    required String date,
  }) => onGetSupervisorShifts!(partnerId: partnerId, date: date);

  @override
  Future<Result<void, Failure>> assignShiftSlot({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  }) => onAssignShiftSlot!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
    shiftSlotId: shiftSlotId,
    attendantId: attendantId,
    isSlotLead: isSlotLead,
  );

  @override
  Future<Result<void, Failure>> unassignShiftSlot({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  }) => onUnassignShiftSlot!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
    assignmentId: assignmentId,
  );

  @override
  Future<Result<void, Failure>> makeSlotLead({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  }) => onMakeSlotLead!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
    assignmentId: assignmentId,
  );

  @override
  Future<Result<RosterEntity, Failure>> createRoster({
    required int partnerId,
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  }) => onCreateRoster!(
    partnerId: partnerId,
    facilityId: facilityId,
    weekStartDate: weekStartDate,
    weekEndDate: weekEndDate,
    offDays: offDays,
  );

  @override
  Future<Result<RosterListEntity, Failure>> getRosters({
    required int partnerId,
    required int facilityId,
    int? page,
  }) => onGetRosters!(partnerId: partnerId, facilityId: facilityId, page: page);

  @override
  Future<Result<RosterEntity, Failure>> publishRoster({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  }) => onPublishRoster!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
  );

  @override
  Future<Result<ShiftEntity, Failure>> createShift({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  }) => onCreateShift!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
    shiftTemplateId: shiftTemplateId,
    shiftDate: shiftDate,
    notes: notes,
    minAttendants: minAttendants,
    maxAttendants: maxAttendants,
  );

  @override
  Future<Result<RosterShiftsEntity, Failure>> getRosterShifts({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  }) => onGetRosterShifts!(
    partnerId: partnerId,
    facilityId: facilityId,
    rosterId: rosterId,
  );

  @override
  Future<Result<List<ShiftTemplateEntity>, Failure>> getShiftTemplates({
    required int partnerId,
  }) => onGetShiftTemplates!(partnerId: partnerId);
}

UserSessionEntity _sessionWithPartner(int partnerId) => UserSessionEntity(
  permissions: const {},
  accessibleFacilities: const [],
  activePartnerId: partnerId,
);

const _partnerId = 6;
const _facilityId = 11;
const _rosterId = 22;

void main() {
  late FakeAuthenticationRepository authRepository;
  late FakeShiftRepository shiftRepository;

  setUp(() {
    authRepository = FakeAuthenticationRepository();
    shiftRepository = FakeShiftRepository();
  });

  group('AssignShiftSlotUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = AssignShiftSlotUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
          shiftSlotId: 1,
          attendantId: 2,
          isSlotLead: false,
        );

        expect(result, const Error<void, Failure>(Failure.partnerUnavailable));
      },
    );

    test('returns Success when the repository succeeds', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onAssignShiftSlot =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required shiftSlotId,
            required attendantId,
            required isSlotLead,
          }) async {
            expect(partnerId, _partnerId);
            return const Success();
          };
      final useCase = AssignShiftSlotUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        shiftSlotId: 1,
        attendantId: 2,
        isSlotLead: true,
      );

      expect(result, const Success<void, Failure>());
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.shiftsUnavailable;
      shiftRepository.onAssignShiftSlot =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required shiftSlotId,
            required attendantId,
            required isSlotLead,
          }) async => const Error(failure);
      final useCase = AssignShiftSlotUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        shiftSlotId: 1,
        attendantId: 2,
        isSlotLead: false,
      );

      expect(result, const Error<void, Failure>(failure));
    });
  });

  group('UnassignShiftSlotUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = UnassignShiftSlotUseCase(
          shiftRepository,
          authRepository,
        );

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
          assignmentId: 5,
        );

        expect(result, const Error<void, Failure>(Failure.partnerUnavailable));
      },
    );

    test('returns Success when the repository succeeds', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onUnassignShiftSlot =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required assignmentId,
          }) async => const Success();
      final useCase = UnassignShiftSlotUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        assignmentId: 5,
      );

      expect(result, const Success<void, Failure>());
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      shiftRepository.onUnassignShiftSlot =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required assignmentId,
          }) async => const Error(failure);
      final useCase = UnassignShiftSlotUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        assignmentId: 5,
      );

      expect(result, const Error<void, Failure>(failure));
    });
  });

  group('MakeSlotLeadUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = MakeSlotLeadUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
          assignmentId: 5,
        );

        expect(result, const Error<void, Failure>(Failure.partnerUnavailable));
      },
    );

    test('returns Success when the repository succeeds', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onMakeSlotLead =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required assignmentId,
          }) async => const Success();
      final useCase = MakeSlotLeadUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        assignmentId: 5,
      );

      expect(result, const Success<void, Failure>());
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.shiftsUnavailable;
      shiftRepository.onMakeSlotLead =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required assignmentId,
          }) async => const Error(failure);
      final useCase = MakeSlotLeadUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        assignmentId: 5,
      );

      expect(result, const Error<void, Failure>(failure));
    });
  });

  group('CreateRosterUseCase', () {
    final roster = const RosterEntity(
      id: 1,
      facilityId: _facilityId,
      weekStartDate: '2026-08-03',
      weekEndDate: '2026-08-09',
      status: 'draft',
    );

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = CreateRosterUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          weekStartDate: '2026-08-03',
          weekEndDate: '2026-08-09',
          offDays: const [5, 6],
        );

        expect(
          result,
          const Error<RosterEntity, Failure>(Failure.partnerUnavailable),
        );
      },
    );

    test('returns Success with the created roster', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onCreateRoster =
          ({
            required partnerId,
            required facilityId,
            required weekStartDate,
            required weekEndDate,
            required offDays,
          }) async => Success(data: roster);
      final useCase = CreateRosterUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        weekStartDate: '2026-08-03',
        weekEndDate: '2026-08-09',
        offDays: const [5, 6],
      );

      expect(result, Success<RosterEntity, Failure>(data: roster));
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      shiftRepository.onCreateRoster =
          ({
            required partnerId,
            required facilityId,
            required weekStartDate,
            required weekEndDate,
            required offDays,
          }) async => const Error(failure);
      final useCase = CreateRosterUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        weekStartDate: '2026-08-03',
        weekEndDate: '2026-08-09',
        offDays: const [5, 6],
      );

      expect(result, const Error<RosterEntity, Failure>(failure));
    });
  });

  group('GetRostersUseCase', () {
    const rosterList = RosterListEntity(
      rosters: [],
      currentPage: 1,
      lastPage: 1,
      total: 0,
    );

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = GetRostersUseCase(shiftRepository, authRepository);

        final result = await useCase.call(facilityId: _facilityId);

        expect(
          result,
          const Error<RosterListEntity, Failure>(Failure.partnerUnavailable),
        );
      },
    );

    test('returns Success with the roster list', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onGetRosters =
          ({required partnerId, required facilityId, page}) async =>
              const Success(data: rosterList);
      final useCase = GetRostersUseCase(shiftRepository, authRepository);

      final result = await useCase.call(facilityId: _facilityId, page: 2);

      expect(
        result,
        const Success<RosterListEntity, Failure>(data: rosterList),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.shiftsUnavailable;
      shiftRepository.onGetRosters =
          ({required partnerId, required facilityId, page}) async =>
              const Error(failure);
      final useCase = GetRostersUseCase(shiftRepository, authRepository);

      final result = await useCase.call(facilityId: _facilityId);

      expect(result, const Error<RosterListEntity, Failure>(failure));
    });
  });

  group('PublishRosterUseCase', () {
    final roster = const RosterEntity(
      id: 1,
      facilityId: _facilityId,
      weekStartDate: '2026-08-03',
      weekEndDate: '2026-08-09',
      status: 'published',
    );

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = PublishRosterUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
        );

        expect(
          result,
          const Error<RosterEntity, Failure>(Failure.partnerUnavailable),
        );
      },
    );

    test('returns Success with the published roster', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onPublishRoster =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
          }) async => Success(data: roster);
      final useCase = PublishRosterUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
      );

      expect(result, Success<RosterEntity, Failure>(data: roster));
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      shiftRepository.onPublishRoster =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
          }) async => const Error(failure);
      final useCase = PublishRosterUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
      );

      expect(result, const Error<RosterEntity, Failure>(failure));
    });
  });

  group('GetRosterShiftsUseCase', () {
    const rosterShifts = RosterShiftsEntity(
      shifts: [],
      stats: RosterShiftStatsEntity(),
    );

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = GetRosterShiftsUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
        );

        expect(
          result,
          const Error<RosterShiftsEntity, Failure>(Failure.partnerUnavailable),
        );
      },
    );

    test('returns Success with the roster shifts', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onGetRosterShifts =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
          }) async => const Success(data: rosterShifts);
      final useCase = GetRosterShiftsUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
      );

      expect(
        result,
        const Success<RosterShiftsEntity, Failure>(data: rosterShifts),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.shiftsUnavailable;
      shiftRepository.onGetRosterShifts =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
          }) async => const Error(failure);
      final useCase = GetRosterShiftsUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
      );

      expect(result, const Error<RosterShiftsEntity, Failure>(failure));
    });
  });

  group('GetShiftTemplatesUseCase', () {
    const templates = [
      ShiftTemplateEntity(
        id: 1,
        name: 'Morning',
        startTime: '08:00',
        endTime: '16:00',
      ),
    ];

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = GetShiftTemplatesUseCase(
          shiftRepository,
          authRepository,
        );

        final result = await useCase.call();

        expect(
          result,
          const Error<List<ShiftTemplateEntity>, Failure>(
            Failure.partnerUnavailable,
          ),
        );
      },
    );

    test('returns Success with the templates', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onGetShiftTemplates = ({required partnerId}) async =>
          const Success(data: templates);
      final useCase = GetShiftTemplatesUseCase(shiftRepository, authRepository);

      final result = await useCase.call();

      expect(
        result,
        const Success<List<ShiftTemplateEntity>, Failure>(data: templates),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      shiftRepository.onGetShiftTemplates = ({required partnerId}) async =>
          const Error(failure);
      final useCase = GetShiftTemplatesUseCase(shiftRepository, authRepository);

      final result = await useCase.call();

      expect(result, const Error<List<ShiftTemplateEntity>, Failure>(failure));
    });
  });

  group('CreateShiftUseCase', () {
    final shift = ShiftEntity(
      id: 1,
      shiftTemplateId: 2,
      facility: const ShiftFacilityEntity(
        id: _facilityId,
        name: 'F',
        address: 'A',
      ),
      shiftTemplateName: 'Morning',
      shiftDate: '2026-08-03',
      startTime: '08:00',
      endTime: '16:00',
      status: 'open',
    );

    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = CreateShiftUseCase(shiftRepository, authRepository);

        final result = await useCase.call(
          facilityId: _facilityId,
          rosterId: _rosterId,
          shiftTemplateId: 2,
          shiftDate: '2026-08-03',
          minAttendants: 1,
          maxAttendants: 3,
        );

        expect(
          result,
          const Error<ShiftEntity, Failure>(Failure.partnerUnavailable),
        );
      },
    );

    test('returns Success with the created shift', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      shiftRepository.onCreateShift =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required shiftTemplateId,
            required shiftDate,
            notes,
            required minAttendants,
            required maxAttendants,
          }) async => Success(data: shift);
      final useCase = CreateShiftUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        shiftTemplateId: 2,
        shiftDate: '2026-08-03',
        minAttendants: 1,
        maxAttendants: 3,
      );

      expect(result, Success<ShiftEntity, Failure>(data: shift));
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.shiftsUnavailable;
      shiftRepository.onCreateShift =
          ({
            required partnerId,
            required facilityId,
            required rosterId,
            required shiftTemplateId,
            required shiftDate,
            notes,
            required minAttendants,
            required maxAttendants,
          }) async => const Error(failure);
      final useCase = CreateShiftUseCase(shiftRepository, authRepository);

      final result = await useCase.call(
        facilityId: _facilityId,
        rosterId: _rosterId,
        shiftTemplateId: 2,
        shiftDate: '2026-08-03',
        minAttendants: 1,
        maxAttendants: 3,
      );

      expect(result, const Error<ShiftEntity, Failure>(failure));
    });
  });
}
