import 'package:flutter_test/flutter_test.dart';

import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/domain/entities/location_ping_entity.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/sign_up_entity.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/location_ping_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/location_ping_use_case.dart';

base class _FakeLocationPingRepository extends LocationPingRepository {
  Result<void, Failure> startTrackingResult = const Success(data: null);
  Result<void, Failure> stopTrackingResult = const Success(data: null);
  Result<void, Failure> syncCurrentLocationResult = const Success(data: null);
  Result<void, Failure> syncLocationPingsResult = const Success(data: null);

  int startTrackingCalls = 0;
  int stopTrackingCalls = 0;
  int? lastSyncedTaskId;
  int? lastSyncedPartnerId;

  @override
  Future<Result<void, Failure>> startTracking({required int taskId}) async {
    startTrackingCalls++;
    return startTrackingResult;
  }

  @override
  Future<Result<void, Failure>> stopTracking() async {
    stopTrackingCalls++;
    return stopTrackingResult;
  }

  @override
  Future<Result<void, Failure>> syncCurrentLocation({
    required int taskId,
  }) async {
    lastSyncedTaskId = taskId;
    return syncCurrentLocationResult;
  }

  @override
  Future<Result<void, Failure>> syncLocationPings({
    required int partnerId,
    required LocationPingSyncRequestEntity request,
  }) async {
    lastSyncedPartnerId = partnerId;
    return syncLocationPingsResult;
  }
}

base class _FakeAuthenticationRepository extends AuthenticationRepository {
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
  UserEntity? getCurrentUser() => throw UnimplementedError();

  @override
  Stream<UserSessionEntity?> watchSession() => throw UnimplementedError();

  @override
  Set<UserPermission> getPermissions() => session?.permissions ?? {};

  @override
  bool hasPermission(UserPermission permission) =>
      getPermissions().contains(permission);

  @override
  List<AccessibleFacilityEntity> getAccessibleFacilities() =>
      session?.accessibleFacilities ?? [];

  @override
  void dispose() {}
}

void main() {
  group('StartLocationPingTrackingUseCase', () {
    test('delegates to the repository', () async {
      final repository = _FakeLocationPingRepository();
      final useCase = StartLocationPingTrackingUseCase(repository);

      final result = await useCase.call(taskId: 7);

      expect(repository.startTrackingCalls, 1);
      expect(result, isA<Success<void, Failure>>());
    });
  });

  group('StopLocationPingTrackingUseCase', () {
    test('delegates to the repository', () async {
      final repository = _FakeLocationPingRepository();
      final useCase = StopLocationPingTrackingUseCase(repository);

      final result = await useCase.call();

      expect(repository.stopTrackingCalls, 1);
      expect(result, isA<Success<void, Failure>>());
    });
  });

  group('SyncCurrentLocationPingUseCase', () {
    test('fails with partnerUnavailable when logged out', () async {
      final repository = _FakeLocationPingRepository();
      final authRepository = _FakeAuthenticationRepository();
      final useCase = SyncCurrentLocationPingUseCase(
        repository,
        authRepository,
      );

      final result = await useCase.call(taskId: 3);

      expect(
        result,
        isA<Error<void, Failure>>().having(
          (e) => e.error,
          'error',
          Failure.partnerUnavailable,
        ),
      );
      expect(repository.lastSyncedTaskId, isNull);
    });

    test('syncs current location when a partner is active', () async {
      final repository = _FakeLocationPingRepository();
      final authRepository = _FakeAuthenticationRepository()
        ..session = UserSessionEntity(
          permissions: const {},
          accessibleFacilities: const [],
          activePartnerId: 9,
        );
      final useCase = SyncCurrentLocationPingUseCase(
        repository,
        authRepository,
      );

      final result = await useCase.call(taskId: 3);

      expect(repository.lastSyncedTaskId, 3);
      expect(result, isA<Success<void, Failure>>());
    });

    test('surfaces the repository failure', () async {
      const failure = Failure(type: FailureType.network, message: 'offline');
      final repository = _FakeLocationPingRepository()
        ..syncCurrentLocationResult = const Error(failure);
      final authRepository = _FakeAuthenticationRepository()
        ..session = UserSessionEntity(
          permissions: const {},
          accessibleFacilities: const [],
          activePartnerId: 9,
        );
      final useCase = SyncCurrentLocationPingUseCase(
        repository,
        authRepository,
      );

      final result = await useCase.call(taskId: 3);

      expect(
        result,
        isA<Error<void, Failure>>().having((e) => e.error, 'error', failure),
      );
    });
  });
}
