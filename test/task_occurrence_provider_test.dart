import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/sign_up_entity.dart';
import 'package:facility_management_app/src/domain/entities/task_occurrence_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/task_occurrence_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/task_occurrence_use_case.dart';
import 'package:facility_management_app/src/presentation/features/occurrence/riverpod/task_occurrence_answer_provider.dart';
import 'package:facility_management_app/src/presentation/features/occurrence/riverpod/task_occurrence_reassign_provider.dart';
import 'package:facility_management_app/src/presentation/features/occurrence/riverpod/task_occurrence_submit_provider.dart';
import 'package:facility_management_app/src/presentation/features/occurrence/riverpod/task_occurrences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
  Future<bool> restoreSession() => throw UnimplementedError();

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

/// Every stub returns a canned [Success] by default and increments its own
/// call counter, so tests can assert *how many times* the list was refetched
/// without wiring a callback for every case.
final class FakeTaskOccurrenceRepository extends TaskOccurrenceRepository {
  int getTaskOccurrencesCallCount = 0;
  TaskOccurrenceListEntity nextList = _occurrenceList;
  Failure? reassignFailure;
  Failure? answerFailure;
  Failure? submitFailure;

  @override
  Future<Result<TaskOccurrenceListEntity, Failure>> getTaskOccurrences({
    required int partnerId,
    required int facilityId,
    String? date,
  }) async {
    getTaskOccurrencesCallCount++;
    return Success(data: nextList);
  }

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> reassignTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
    required int assignedTo,
  }) async {
    if (reassignFailure != null) return Error(reassignFailure!);
    return const Success(data: _occurrence);
  }

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
  }) async {
    if (answerFailure != null) return Error(answerFailure!);
    return const Success(data: ChecklistItemAnswerEntity(ratingValue: 5));
  }

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> submitTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
  }) async {
    if (submitFailure != null) return Error(submitFailure!);
    return const Success(data: _occurrence);
  }
}

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

void main() {
  late FakeAuthenticationRepository authRepository;
  late FakeTaskOccurrenceRepository taskOccurrenceRepository;
  late ProviderContainer container;

  setUp(() {
    authRepository = FakeAuthenticationRepository()
      ..session = UserSessionEntity(
        permissions: const {},
        accessibleFacilities: const [],
        activePartnerId: _partnerId,
      );
    taskOccurrenceRepository = FakeTaskOccurrenceRepository();

    container = ProviderContainer(
      overrides: [
        getTaskOccurrencesUseCaseProvider.overrideWithValue(
          GetTaskOccurrencesUseCase(taskOccurrenceRepository, authRepository),
        ),
        reassignTaskOccurrenceUseCaseProvider.overrideWithValue(
          ReassignTaskOccurrenceUseCase(
            taskOccurrenceRepository,
            authRepository,
          ),
        ),
        answerTaskOccurrenceChecklistItemUseCaseProvider.overrideWithValue(
          AnswerTaskOccurrenceChecklistItemUseCase(
            taskOccurrenceRepository,
            authRepository,
          ),
        ),
        submitTaskOccurrenceUseCaseProvider.overrideWithValue(
          SubmitTaskOccurrenceUseCase(taskOccurrenceRepository, authRepository),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TaskOccurrences', () {
    test('fetch populates state with the occurrence list', () async {
      await container
          .read(taskOccurrencesProvider.notifier)
          .fetch(facilityId: _facilityId, date: '2026-08-26');

      expect(container.read(taskOccurrencesProvider).value, _occurrenceList);
      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);
    });

    test('refetches the list after a successful reassign', () async {
      // WHY: ref.listen only wires up once the notifier's build() has run,
      // and autoDispose would tear taskOccurrencesProvider back down between
      // awaits without a live subscription — keep one open for the test.
      final sub = container.listen(taskOccurrencesProvider, (_, _) {});
      await container
          .read(taskOccurrencesProvider.notifier)
          .fetch(facilityId: _facilityId, date: '2026-08-26');
      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);

      await container
          .read(taskOccurrenceReassignProvider.notifier)
          .reassign(taskOccurrenceId: _taskOccurrenceId, assignedTo: 12);

      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 2);
      sub.close();
    });

    test('refetches the list after a successful answer', () async {
      final sub = container.listen(taskOccurrencesProvider, (_, _) {});
      await container
          .read(taskOccurrencesProvider.notifier)
          .fetch(facilityId: _facilityId, date: '2026-08-26');
      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);

      await container
          .read(taskOccurrenceChecklistAnswerProvider.notifier)
          .answer(
            taskOccurrenceId: _taskOccurrenceId,
            itemId: 4,
            ratingValue: 5,
          );

      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 2);
      sub.close();
    });

    test('refetches the list after a successful submit', () async {
      final sub = container.listen(taskOccurrencesProvider, (_, _) {});
      await container
          .read(taskOccurrencesProvider.notifier)
          .fetch(facilityId: _facilityId, date: '2026-08-26');
      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);

      await container
          .read(taskOccurrenceSubmitProvider.notifier)
          .submit(taskOccurrenceId: _taskOccurrenceId);

      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 2);
      sub.close();
    });

    test('does not refetch when a reassign fails', () async {
      final sub = container.listen(taskOccurrencesProvider, (_, _) {});
      await container
          .read(taskOccurrencesProvider.notifier)
          .fetch(facilityId: _facilityId, date: '2026-08-26');
      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);
      taskOccurrenceRepository.reassignFailure = const Failure(
        type: FailureType.forbidden,
        message: 'You are not assigned to this occurrence.',
      );

      await container
          .read(taskOccurrenceReassignProvider.notifier)
          .reassign(taskOccurrenceId: _taskOccurrenceId, assignedTo: 12);

      expect(taskOccurrenceRepository.getTaskOccurrencesCallCount, 1);
      sub.close();
    });
  });

  group('TaskOccurrenceReassign', () {
    test('state holds the reassigned occurrence on success', () async {
      final result = await container
          .read(taskOccurrenceReassignProvider.notifier)
          .reassign(taskOccurrenceId: _taskOccurrenceId, assignedTo: 12);

      expect(
        result,
        const Success<TaskOccurrenceEntity, Failure>(data: _occurrence),
      );
      expect(container.read(taskOccurrenceReassignProvider).value, _occurrence);
    });

    test('state holds the failure on error', () async {
      const failure = Failure(
        type: FailureType.forbidden,
        message: 'You are not assigned to this occurrence.',
      );
      taskOccurrenceRepository.reassignFailure = failure;

      final result = await container
          .read(taskOccurrenceReassignProvider.notifier)
          .reassign(taskOccurrenceId: _taskOccurrenceId, assignedTo: 12);

      expect(result, const Error<TaskOccurrenceEntity, Failure>(failure));
      expect(container.read(taskOccurrenceReassignProvider).hasError, isTrue);
    });
  });
}
