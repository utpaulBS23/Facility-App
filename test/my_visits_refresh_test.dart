import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/visit_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/visit_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/visit_use_case.dart';
import 'package:facility_management_app/src/presentation/features/my_visits/riverpod/my_visits_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuth extends AuthenticationRepository {
  @override
  UserSessionEntity? get currentSession => UserSessionEntity(
    permissions: const {},
    accessibleFacilities: const [],
    activePartnerId: 7,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Answers the visit list, or fails once told to.
final class _FakeVisits extends VisitRepository {
  var fail = false;
  var calls = 0;

  @override
  Stream<int> get onVisitSubmitted => const Stream.empty();

  @override
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    String? date,
    String? status,
    int? facilityId,
    int? assignedTo,
    int? page,
    int? perPage,
  }) async {
    calls++;
    if (fail) return const Error(Failure.partnerUnavailable);

    return const Success(data: VisitListEntity(visits: []));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeVisits repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeVisits();
    final auth = _FakeAuth();
    container = ProviderContainer(
      overrides: [
        getMyVisitsUseCaseProvider.overrideWithValue(
          GetMyVisitsUseCase(repository, auth),
        ),
        watchVisitSubmittedUseCaseProvider.overrideWithValue(
          WatchVisitSubmittedUseCase(repository),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('a normal fetch shows the spinner while it loads', () async {
    final notifier = container.read(myVisitsProvider.notifier);
    await notifier.fetch(date: '2026-10-07');

    final states = <bool>[];
    container.listen(
      myVisitsProvider,
      (_, next) => states.add(next.isLoading),
    );
    await notifier.fetch(date: '2026-10-07');

    expect(states.first, isTrue);
  });

  test('a silent refresh keeps the list on screen while it loads', () async {
    final notifier = container.read(myVisitsProvider.notifier);
    await notifier.fetch(date: '2026-10-07');

    final states = <bool>[];
    container.listen(
      myVisitsProvider,
      (_, next) => states.add(next.isLoading),
    );
    await notifier.refresh();

    expect(states, isNot(contains(true)));
    expect(container.read(myVisitsProvider).hasValue, isTrue);
  });

  test('a failed silent refresh keeps the list it had', () async {
    final notifier = container.read(myVisitsProvider.notifier);
    await notifier.fetch(date: '2026-10-07');

    repository.fail = true;
    await notifier.refresh();

    expect(container.read(myVisitsProvider).hasError, isFalse);
    expect(container.read(myVisitsProvider).hasValue, isTrue);
  });
}
