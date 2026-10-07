import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/task_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/task_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/task_use_case.dart';
import 'package:facility_management_app/src/presentation/features/tasks/riverpod/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuth extends AuthenticationRepository {
  @override
  UserSessionEntity? get currentSession =>
      UserSessionEntity(
        permissions: const {},
        accessibleFacilities: const [],
        activePartnerId: 7,
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Answers the issue list and records the filters it was asked with.
final class _FakeTasks extends TaskRepository {
  final calls = <({String? status, int? facilityId})>[];
  var title = 'Leak';

  @override
  Future<Result<List<TaskEntity>, Failure>> getIssues({
    required int partnerId,
    String? status,
    int? facilityId,
  }) async {
    calls.add((status: status, facilityId: facilityId));

    return Success(
      data: [
        TaskEntity(
          id: 1,
          title: title,
          description: '',
          location: '',
          dueTime: '',
          priority: TaskPriority.medium,
          status: TaskStatus.open,
        ),
      ],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeTasks repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeTasks();
    container = ProviderContainer(
      overrides: [
        getIssuesUseCaseProvider.overrideWithValue(
          GetIssuesUseCase(repository, _FakeAuth()),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('refresh repeats the last fetch with the same filters', () async {
    final notifier = container.read(tasksProvider.notifier);
    await notifier.fetch(status: 'in_progress', facilityId: 3);

    repository.title = 'Leak fixed';
    await notifier.refresh();

    expect(repository.calls.last, (status: 'in_progress', facilityId: 3));
    expect(repository.calls.length, 2);
    expect(container.read(tasksProvider).value!.single.title, 'Leak fixed');
  });

  test('refresh does nothing while the list was never loaded', () async {
    await container.read(tasksProvider.notifier).refresh();

    expect(repository.calls, isEmpty);
  });
}
