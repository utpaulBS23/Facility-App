import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:facility_management_app/src/data/repositories/authentication_repository_impl.dart';
import 'package:facility_management_app/src/data/services/network/rest_client.dart';
import 'package:facility_management_app/src/data/services/session/session_service.dart';

/// Guards the invariant that authentication has exactly one owner.
///
/// The bug this pins: `TokenManager` clears the token from inside the Dio
/// interceptor when a refresh fails. That path is invisible to the repository,
/// so the session it holds used to survive its own token — leaving the app
/// with permissions it could not exercise and a router that let it through.
void main() {
  group('InMemorySessionService', () {
    test('reports authentication from the token it holds', () {
      final service = InMemorySessionService();
      addTearDown(service.dispose);

      expect(service.isAuthenticated, isFalse);

      service.setAccessToken('token');
      expect(service.isAuthenticated, isTrue);
      expect(service.accessToken, 'token');

      service.clear();
      expect(service.isAuthenticated, isFalse);
      expect(service.accessToken, isNull);
    });

    test('emits once per clear, and not at all when already empty', () async {
      final service = InMemorySessionService();
      addTearDown(service.dispose);

      var emissions = 0;
      final subscription = service.onCleared.listen((_) => emissions++);
      addTearDown(subscription.cancel);

      // Already empty — a logout racing a failed refresh must not double-fire.
      service.clear();
      await pumpEventQueue();
      expect(emissions, 0);

      service.setAccessToken('token');
      service.clear();
      await pumpEventQueue();
      expect(emissions, 1);

      service.clear();
      await pumpEventQueue();
      expect(emissions, 1);
    });
  });

  group('AuthenticationRepositoryImpl', () {
    late InMemorySessionService session;
    late AuthenticationRepositoryImpl repository;

    setUp(() {
      session = InMemorySessionService();
      // No request is issued in these tests; the client is only a constructor
      // dependency, so a bare Dio is enough.
      repository = AuthenticationRepositoryImpl(
        remote: RestClient(Dio()),
        session: session,
      );
    });

    tearDown(() {
      repository.dispose();
      session.dispose();
    });

    test('a token cleared from outside tears the session down', () async {
      final emitted = <Object?>[];
      final subscription = repository.watchSession().listen(emitted.add);
      addTearDown(subscription.cancel);

      session.setAccessToken('token');

      // Exactly what TokenManager._handleRefreshFailure does — the repository
      // is never told directly.
      session.clear();
      await pumpEventQueue();

      expect(emitted, [
        null,
      ], reason: 'listeners must be told the session died');
      expect(repository.currentSession, isNull);
      expect(session.isAuthenticated, isFalse);
    });

    test('logout goes through the same single teardown path', () async {
      final emitted = <Object?>[];
      final subscription = repository.watchSession().listen(emitted.add);
      addTearDown(subscription.cancel);

      session.setAccessToken('token');
      await repository.logout();
      await pumpEventQueue();

      expect(emitted, [null], reason: 'one emission, not one per owner');
      expect(repository.currentSession, isNull);
      expect(session.isAuthenticated, isFalse);
    });

    test('disposal stops the repository listening to the token', () async {
      session.setAccessToken('token');
      repository.dispose();

      // Must not throw on the closed session controller.
      session.clear();
      await pumpEventQueue();

      expect(session.isAuthenticated, isFalse);
    });
  });
}
