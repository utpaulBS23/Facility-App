import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:facility_management_app/src/data/repositories/authentication_repository_impl.dart';
import 'package:facility_management_app/src/data/services/network/rest_client.dart';
import 'package:facility_management_app/src/data/services/secure_storage/secure_storage_service.dart';
import 'package:facility_management_app/src/data/services/session/session_service.dart';

class _FakeSecureStorageService implements SecureStorageService {
  final Map<SecureStorageKey, String> _values = {};

  @override
  Future<void> save(SecureStorageKey key, String value) async {
    _values[key] = value;
  }

  @override
  Future<String?> read(SecureStorageKey key) async => _values[key];

  @override
  Future<void> delete(SecureStorageKey key) async {
    _values.remove(key);
  }
}

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
    late _FakeSecureStorageService secureStorage;
    late AuthenticationRepositoryImpl repository;

    setUp(() {
      session = InMemorySessionService();
      secureStorage = _FakeSecureStorageService();
      // No request is issued in these tests; the client is only a constructor
      // dependency, so a bare Dio is enough.
      repository = AuthenticationRepositoryImpl(
        remote: RestClient(Dio()),
        session: session,
        secureStorage: secureStorage,
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

    test('logout clears the persisted session even when something disposes '
        'the repository right after (resetRepositories-style race)', () async {
      session.setAccessToken('token');
      await secureStorage.save(SecureStorageKey.sessionPayload, '{}');

      // WHY no pumpEventQueue between clear() and dispose(): this
      // reproduces resetRepositories() invalidating the repository
      // provider synchronously right after logout()'s session.clear()
      // call, before any pending microtask could run. Without the fix
      // (a sync onCleared stream), that dispose cancels the listener
      // before it ever fires and the persisted payload survives logout.
      session.clear();
      repository.dispose();

      expect(
        await secureStorage.read(SecureStorageKey.sessionPayload),
        isNull,
        reason:
            'a still-persisted payload rehydrates a logged-out user '
            'straight past the login screen on next launch',
      );
    });

    test('disposal stops the repository listening to the token', () async {
      session.setAccessToken('token');
      repository.dispose();

      // Must not throw on the closed session controller.
      session.clear();
      await pumpEventQueue();

      expect(session.isAuthenticated, isFalse);
    });

    test('restoreSession returns false when nothing was persisted', () async {
      final restored = await repository.restoreSession();

      expect(restored, isFalse);
      expect(repository.currentSession, isNull);
      expect(session.isAuthenticated, isFalse);
    });

    test(
      'restoreSession rehydrates the session from a stored login payload',
      () async {
        await secureStorage.save(SecureStorageKey.sessionPayload, '''
      {
        "user": {
          "id": 1,
          "name": "Sharmin Jahan",
          "email": "sharmin@example.com",
          "user_type": "attendant",
          "permission_version": 1,
          "two_factor_enabled": false
        },
        "token": {"access_token": "restored-token", "type": "bearer"},
        "permissions": [],
        "accessible_facilities": []
      }
      ''');

        final restored = await repository.restoreSession();

        expect(restored, isTrue);
        expect(session.accessToken, 'restored-token');
        expect(repository.currentSession, isNotNull);
        expect(repository.getCurrentUser()?.name, 'Sharmin Jahan');
      },
    );

    test('restoreSession clears a malformed stored payload', () async {
      await secureStorage.save(SecureStorageKey.sessionPayload, 'not json');

      final restored = await repository.restoreSession();

      expect(restored, isFalse);
      expect(await secureStorage.read(SecureStorageKey.sessionPayload), isNull);
    });
  });
}
