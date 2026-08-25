import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/sign_up_entity.dart';
import 'package:facility_management_app/src/domain/entities/task_occurrence_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/task_occurrence_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/task_occurrence_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hand-written test double — this project has no mockito/mocktail
/// dependency (see pubspec.yaml), so existing tests (e.g.
/// shift_use_case_test.dart) exercise real/fake implementations directly.
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
  Future<Result<SignUpResponseEntity, Failure>> register(
    SignUpRequestEntity data,
  ) => throw UnimplementedError();

  @override
  Future<Result<LoginResponseEntity, Failure>> login(LoginRequestEntity data) =>
      throw UnimplementedError();

  @override
  Future<Result<String, Failure>> forgotPassword(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<Result<String, Failure>> resetPassword(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<Result<String, Failure>> verifyOTP(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<Result<String, Failure>> resendOTP(Map<String, dynamic> data) =>
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
final class FakeTaskOccurrenceRepository extends TaskOccurrenceRepository {
  Future<Result<TaskOccurrenceListEntity, Failure>> Function({
    required int partnerId,
    required int facilityId,
    String? date,
  })?
  onGetTaskOccurrences;
  Future<Result<TaskOccurrenceEntity, Failure>> Function({
    required int partnerId,
    required int taskOccurrenceId,
    required int assignedTo,
  })?
  onReassignTaskOccurrence;
  Future<Result<ChecklistItemAnswerEntity, Failure>> Function({
    required int partnerId,
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  })?
  onAnswerTaskOccurrenceChecklistItem;
  Future<Result<TaskOccurrenceEntity, Failure>> Function({
    required int partnerId,
    required int taskOccurrenceId,
  })?
  onSubmitTaskOccurrence;

  @override
  Future<Result<TaskOccurrenceListEntity, Failure>> getTaskOccurrences({
    required int partnerId,
    required int facilityId,
    String? date,
  }) => onGetTaskOccurrences!(
    partnerId: partnerId,
    facilityId: facilityId,
    date: date,
  );

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> reassignTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
    required int assignedTo,
  }) => onReassignTaskOccurrence!(
    partnerId: partnerId,
    taskOccurrenceId: taskOccurrenceId,
    assignedTo: assignedTo,
  );

  @override
  Future<Result<ChecklistItemAnswerEntity, Failure>>
  answerTaskOccurrenceChecklistItem({
    required int partnerId,
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  }) => onAnswerTaskOccurrenceChecklistItem!(
    partnerId: partnerId,
    taskOccurrenceId: taskOccurrenceId,
    itemId: itemId,
    ratingValue: ratingValue,
    booleanValue: booleanValue,
    textValue: textValue,
    photoPath: photoPath,
    alt: alt,
  );

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> submitTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
  }) => onSubmitTaskOccurrence!(
    partnerId: partnerId,
    taskOccurrenceId: taskOccurrenceId,
  );
}

UserSessionEntity _sessionWithPartner(int partnerId) => UserSessionEntity(
  permissions: const {},
  accessibleFacilities: const [],
  activePartnerId: partnerId,
);

const _partnerId = 6;
const _facilityId = 37;
const _taskOccurrenceId = 137;

const _occurrence = TaskOccurrenceEntity(
  id: _taskOccurrenceId,
  taskScheduleId: 6,
  scheduleTitle: 'Toilet Cleaning',
  taskType: 'visit',
  facilityId: _facilityId,
  occurrenceDate: '2026-08-26',
  slotStart: '06:00',
  slotEnd: '08:00',
  timeRange: '06:00-08:00',
  status: TaskOccurrenceStatus.pending,
);

const _occurrenceList = TaskOccurrenceListEntity(
  occurrences: [_occurrence],
  stats: TaskOccurrenceStatsEntity(
    totalSlots: 1,
    onTime: 0,
    late: 0,
    missed: 0,
    pending: 1,
    complianceScore: 0,
  ),
);

const _answer = ChecklistItemAnswerEntity(ratingValue: 5, hasProof: true);

void main() {
  late FakeAuthenticationRepository authRepository;
  late FakeTaskOccurrenceRepository taskOccurrenceRepository;

  setUp(() {
    authRepository = FakeAuthenticationRepository();
    taskOccurrenceRepository = FakeTaskOccurrenceRepository();
  });

  group('GetTaskOccurrencesUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = GetTaskOccurrencesUseCase(
          taskOccurrenceRepository,
          authRepository,
        );

        final result = await useCase.call(facilityId: _facilityId);

        expect(
          result,
          const Error<TaskOccurrenceListEntity, Failure>(
            Failure.partnerUnavailable,
          ),
        );
      },
    );

    test('returns Success with the occurrence list', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      taskOccurrenceRepository.onGetTaskOccurrences =
          ({required partnerId, required facilityId, date}) async {
            expect(partnerId, _partnerId);
            expect(facilityId, _facilityId);
            return const Success(data: _occurrenceList);
          };
      final useCase = GetTaskOccurrencesUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(
        facilityId: _facilityId,
        date: '2026-08-26',
      );

      expect(
        result,
        const Success<TaskOccurrenceListEntity, Failure>(data: _occurrenceList),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.noAccessibleFacility;
      taskOccurrenceRepository.onGetTaskOccurrences =
          ({required partnerId, required facilityId, date}) async =>
              const Error(failure);
      final useCase = GetTaskOccurrencesUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(facilityId: _facilityId);

      expect(result, const Error<TaskOccurrenceListEntity, Failure>(failure));
    });
  });

  group('ReassignTaskOccurrenceUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = ReassignTaskOccurrenceUseCase(
          taskOccurrenceRepository,
          authRepository,
        );

        final result = await useCase.call(
          taskOccurrenceId: _taskOccurrenceId,
          assignedTo: 12,
        );

        expect(
          result,
          const Error<TaskOccurrenceEntity, Failure>(
            Failure.partnerUnavailable,
          ),
        );
      },
    );

    test('returns Success with the reassigned occurrence', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      taskOccurrenceRepository.onReassignTaskOccurrence =
          ({
            required partnerId,
            required taskOccurrenceId,
            required assignedTo,
          }) async {
            expect(partnerId, _partnerId);
            expect(taskOccurrenceId, _taskOccurrenceId);
            expect(assignedTo, 12);
            return const Success(data: _occurrence);
          };
      final useCase = ReassignTaskOccurrenceUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(
        taskOccurrenceId: _taskOccurrenceId,
        assignedTo: 12,
      );

      expect(
        result,
        const Success<TaskOccurrenceEntity, Failure>(data: _occurrence),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      taskOccurrenceRepository.onReassignTaskOccurrence =
          ({
            required partnerId,
            required taskOccurrenceId,
            required assignedTo,
          }) async => const Error(failure);
      final useCase = ReassignTaskOccurrenceUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(
        taskOccurrenceId: _taskOccurrenceId,
        assignedTo: 12,
      );

      expect(result, const Error<TaskOccurrenceEntity, Failure>(failure));
    });
  });

  group('AnswerTaskOccurrenceChecklistItemUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = AnswerTaskOccurrenceChecklistItemUseCase(
          taskOccurrenceRepository,
          authRepository,
        );

        final result = await useCase.call(
          taskOccurrenceId: _taskOccurrenceId,
          itemId: 4,
          ratingValue: 5,
        );

        expect(
          result,
          const Error<ChecklistItemAnswerEntity, Failure>(
            Failure.partnerUnavailable,
          ),
        );
      },
    );

    test('returns Success with the saved answer', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      taskOccurrenceRepository.onAnswerTaskOccurrenceChecklistItem =
          ({
            required partnerId,
            required taskOccurrenceId,
            required itemId,
            ratingValue,
            booleanValue,
            textValue,
            photoPath,
            alt,
          }) async {
            expect(partnerId, _partnerId);
            expect(taskOccurrenceId, _taskOccurrenceId);
            expect(itemId, 4);
            expect(ratingValue, 5);
            return const Success(data: _answer);
          };
      final useCase = AnswerTaskOccurrenceChecklistItemUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(
        taskOccurrenceId: _taskOccurrenceId,
        itemId: 4,
        ratingValue: 5,
      );

      expect(
        result,
        const Success<ChecklistItemAnswerEntity, Failure>(data: _answer),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure.permissionDenied;
      taskOccurrenceRepository.onAnswerTaskOccurrenceChecklistItem =
          ({
            required partnerId,
            required taskOccurrenceId,
            required itemId,
            ratingValue,
            booleanValue,
            textValue,
            photoPath,
            alt,
          }) async => const Error(failure);
      final useCase = AnswerTaskOccurrenceChecklistItemUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(
        taskOccurrenceId: _taskOccurrenceId,
        itemId: 4,
        ratingValue: 5,
      );

      expect(result, const Error<ChecklistItemAnswerEntity, Failure>(failure));
    });
  });

  group('SubmitTaskOccurrenceUseCase', () {
    test(
      'returns partnerUnavailable when the session has no partner',
      () async {
        final useCase = SubmitTaskOccurrenceUseCase(
          taskOccurrenceRepository,
          authRepository,
        );

        final result = await useCase.call(
          taskOccurrenceId: _taskOccurrenceId,
        );

        expect(
          result,
          const Error<TaskOccurrenceEntity, Failure>(
            Failure.partnerUnavailable,
          ),
        );
      },
    );

    test('returns Success with the submitted occurrence', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      taskOccurrenceRepository.onSubmitTaskOccurrence =
          ({required partnerId, required taskOccurrenceId}) async {
            expect(partnerId, _partnerId);
            expect(taskOccurrenceId, _taskOccurrenceId);
            return const Success(data: _occurrence);
          };
      final useCase = SubmitTaskOccurrenceUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(taskOccurrenceId: _taskOccurrenceId);

      expect(
        result,
        const Success<TaskOccurrenceEntity, Failure>(data: _occurrence),
      );
    });

    test('passes the repository error through unchanged', () async {
      authRepository.session = _sessionWithPartner(_partnerId);
      const failure = Failure(
        type: FailureType.notFound,
        message: 'Occurrence not found.',
      );
      taskOccurrenceRepository.onSubmitTaskOccurrence =
          ({required partnerId, required taskOccurrenceId}) async =>
              const Error(failure);
      final useCase = SubmitTaskOccurrenceUseCase(
        taskOccurrenceRepository,
        authRepository,
      );

      final result = await useCase.call(taskOccurrenceId: _taskOccurrenceId);

      expect(result, const Error<TaskOccurrenceEntity, Failure>(failure));
    });
  });
}
