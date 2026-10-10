import 'dart:async';

import 'package:dio/dio.dart';
import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/data/models/notification/device_token_model.dart';
import 'package:facility_management_app/src/data/repositories/device_token_repository_impl.dart';
import 'package:facility_management_app/src/data/services/cache/cache_service.dart';
import 'package:facility_management_app/src/data/services/network/rest_client.dart';
import 'package:facility_management_app/src/domain/repositories/device_token_repository.dart';
import 'package:facility_management_app/src/domain/repositories/push_notification_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/notification/device_token_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retrofit/retrofit.dart';

class _MemoryCache implements CacheService {
  final values = <CacheKey, Object>{};

  @override
  Future<void> save<T>(CacheKey key, T value) async => values[key] = value as Object;

  @override
  T? get<T>(CacheKey key) => values[key] as T?;

  @override
  Future<void> remove(List<CacheKey> keys) async => keys.forEach(values.remove);

  @override
  Future<void> clear() async => values.clear();
}

DioException _status(int code) => DioException(
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions(), statusCode: code),
  type: DioExceptionType.badResponse,
);

class _FakeClient implements RestClient {
  final calls = <String>[];
  int nextId = 7;
  String? lastPlatform;
  DioException? syncError;
  DioException? deleteError;
  Completer<void>? deleteGate;

  HttpResponse _ok(Object data) => HttpResponse(
    data,
    Response(requestOptions: RequestOptions(), statusCode: 200),
  );

  @override
  Future<HttpResponse> registerDeviceToken({
    required DeviceTokenRequestModel body,
  }) async {
    calls.add('register ${body.fcmToken}');
    lastPlatform = body.platform;

    return _ok({'id': nextId, 'platform': 'android'});
  }

  @override
  Future<HttpResponse> syncDeviceTokenTopics({
    required int id,
    Map<String, dynamic> body = const {},
  }) async {
    calls.add('sync $id');
    final error = syncError;
    if (error != null) throw error;

    return _ok({'topics': <String>[]});
  }

  @override
  Future<HttpResponse> deleteDeviceToken({required int id}) async {
    calls.add('delete $id');
    final gate = deleteGate;
    if (gate != null) await gate.future;
    final error = deleteError;
    if (error != null) throw error;

    return _ok('');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakePush extends PushNotificationRepository {
  _FakePush(this.token);

  String token;

  @override
  Future<String> getDeviceToken() async => token;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _RecordingDevices extends DeviceTokenRepository {
  _RecordingDevices(this.log, {this.registered = false});

  final List<String> log;
  bool registered;
  Failure? syncFailure;

  @override
  bool get isRegistered => registered;

  @override
  Future<Result<void, Failure>> register(String fcmToken) async {
    log.add('register $fcmToken');
    registered = true;

    return const Success();
  }

  @override
  Future<Result<void, Failure>> syncTopics({bool force = false}) async {
    log.add('sync');
    final failure = syncFailure;

    return failure == null ? const Success() : Error(failure);
  }

  @override
  Future<Result<void, Failure>> unregister() async {
    log.add('unregister');

    return const Success();
  }
}

void main() {
  group('device token repository', () {
    late _FakeClient client;
    late _MemoryCache cache;
    late DeviceTokenRepositoryImpl repository;

    setUp(() {
      client = _FakeClient();
      cache = _MemoryCache();
      repository = DeviceTokenRepositoryImpl(
        remote: client,
        local: cache,
        platform: 'android',
      );
    });

    test('registers, stores the id and syncs the topics', () async {
      final result = await repository.register('token-a');

      expect(result, isA<Success<void, Failure>>());
      expect(client.calls, ['register token-a', 'sync 7']);
      expect(cache.get<int>(CacheKey.deviceTokenId), 7);
      expect(repository.isRegistered, isTrue);
    });

    test('registers with the platform the repository was given', () async {
      await repository.register('token-a');

      expect(client.lastPlatform, 'android');
    });

    test('a failed sync does not fail the registration', () async {
      client.syncError = _status(500);

      final result = await repository.register('token-a');

      expect(result, isA<Success<void, Failure>>());
      expect(repository.isRegistered, isTrue);
    });

    test('a rotated token removes the earlier one afterwards', () async {
      await repository.register('token-a');
      client.nextId = 9;
      client.calls.clear();

      await repository.register('token-b');

      expect(client.calls, ['register token-b', 'sync 9', 'delete 7']);
      expect(cache.get<int>(CacheKey.deviceTokenId), 9);
    });

    test('a missing earlier token is ignored on rotation', () async {
      await repository.register('token-a');
      client.nextId = 9;
      client.deleteError = _status(404);

      final result = await repository.register('token-b');

      expect(result, isA<Success<void, Failure>>());
    });

    test('registering the same token again does not delete it', () async {
      await repository.register('token-a');
      client.calls.clear();

      await repository.register('token-a');

      expect(client.calls, ['register token-a', 'sync 7']);
    });

    test('a recent sync is skipped, a forced one is not', () async {
      await repository.register('token-a');
      client.calls.clear();

      await repository.syncTopics();
      expect(client.calls, isEmpty);

      await repository.syncTopics(force: true);
      expect(client.calls, ['sync 7']);
    });

    test('an old sync runs again', () async {
      await repository.register('token-a');
      await cache.save(
        CacheKey.deviceTokenSyncedAt,
        DateTime.now()
            .subtract(const Duration(hours: 7))
            .millisecondsSinceEpoch,
      );
      client.calls.clear();

      await repository.syncTopics();

      expect(client.calls, ['sync 7']);
    });

    test('syncing before registering does nothing', () async {
      final result = await repository.syncTopics(force: true);

      expect(result, isA<Success<void, Failure>>());
      expect(client.calls, isEmpty);
    });

    test('a 404 on sync forgets the id and reports not found', () async {
      await repository.register('token-a');
      client.syncError = _status(404);

      final result = await repository.syncTopics(force: true);

      expect(result, isA<Error<void, Failure>>());
      expect((result as Error<void, Failure>).error.type, FailureType.notFound);
      expect(repository.isRegistered, isFalse);
    });

    test('unregister deletes the token and forgets it', () async {
      await repository.register('token-a');
      client.calls.clear();

      await repository.unregister();

      expect(client.calls, ['delete 7']);
      expect(repository.isRegistered, isFalse);
    });

    test('unregister treats an already deleted token as done', () async {
      await repository.register('token-a');
      client.deleteError = _status(404);

      final result = await repository.unregister();

      expect(result, isA<Success<void, Failure>>());
      expect(repository.isRegistered, isFalse);
    });

    test('a slow unregister does not erase a newer registration', () async {
      await repository.register('token-a');
      final slow = Completer<void>();
      client.deleteGate = slow;

      final unregistering = repository.unregister();
      // Signed in again while the old delete is still on its way.
      client.nextId = 9;
      client.deleteGate = null;
      await repository.register('token-b');
      await Future<void>.delayed(Duration.zero);
      expect(cache.get<int>(CacheKey.deviceTokenId), 9);

      slow.complete();
      await unregistering;

      expect(cache.get<int>(CacheKey.deviceTokenId), 9);
    });

    test('unregister before registering makes no request', () async {
      await repository.unregister();

      expect(client.calls, isEmpty);
    });
  });

  group('use cases', () {
    test('unregister asks the repository to remove the device', () async {
      final log = <String>[];

      await UnregisterDeviceTokenUseCase(_RecordingDevices(log))();

      expect(log, ['unregister']);
    });

    test('sync registers first when the device is not registered', () async {
      final log = <String>[];
      final useCase = SyncDeviceTopicsUseCase(
        _FakePush('token-a'),
        _RecordingDevices(log),
      );

      await useCase();

      expect(log, ['register token-a']);
    });

    test('sync registers again when the server lost the token', () async {
      final log = <String>[];
      final devices = _RecordingDevices(log, registered: true)
        ..syncFailure = const Failure(
          type: FailureType.notFound,
          message: 'Device token not found.',
        );

      await SyncDeviceTopicsUseCase(_FakePush('token-a'), devices)();

      expect(log, ['sync', 'register token-a']);
    });

    test('sync alone is enough when the token is known', () async {
      final log = <String>[];

      await SyncDeviceTopicsUseCase(
        _FakePush('token-a'),
        _RecordingDevices(log, registered: true),
      )();

      expect(log, ['sync']);
    });

    test('no token means nothing to register', () async {
      final log = <String>[];

      final result = await RegisterDeviceTokenUseCase(
        _FakePush(''),
        _RecordingDevices(log),
      )();

      expect(result, isA<Success<void, Failure>>());
      expect(log, isEmpty);
    });

    test('a rotated token is registered as given', () async {
      final log = <String>[];

      await RegisterDeviceTokenUseCase(
        _FakePush('old'),
        _RecordingDevices(log),
      )(token: 'new');

      expect(log, ['register new']);
    });
  });
}
