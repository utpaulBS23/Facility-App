import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/core/di/dependency_injection.dart';
import 'package:facility_management_app/src/domain/entities/app_update_entity.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/sign_up_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_update_repository.dart';
import 'package:facility_management_app/src/domain/repositories/authentication_repository.dart';
import 'package:facility_management_app/src/domain/repositories/device_info_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/app_update_use_case.dart';
import 'package:facility_management_app/src/domain/use_cases/authentication_use_case.dart';
import 'package:facility_management_app/src/domain/use_cases/device_info_use_case.dart';
import 'package:facility_management_app/src/presentation/features/app_update/riverpod/app_update_download_provider.dart';
import 'package:facility_management_app/src/presentation/features/app_update/riverpod/app_update_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeAppUpdateRepo extends AppUpdateRepository {
  AppUpdateCheckResponseEntity? checkResponse;
  Failure? checkFailure;
  AppUpdateActionRequestEntity? lastReportedAction;
  String? installedPath;

  @override
  Future<Result<AppUpdateCheckResponseEntity, Failure>> checkVersion({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  }) async {
    if (checkFailure != null) {
      return Error(checkFailure!);
    }
    if (checkResponse != null) {
      return Success(data: checkResponse!);
    }
    return const Success(
      data: AppUpdateCheckResponseEntity(
        updateType: UpdateType.none,
        installSource: InstallSource.sideload,
        eventId: 1,
      ),
    );
  }

  @override
  Future<Result<bool, Failure>> reportUpdateAction(
    AppUpdateActionRequestEntity request,
  ) async {
    lastReportedAction = request;
    return const Success(data: true);
  }

  @override
  Stream<DownloadProgressEntity> downloadAndVerifyApk({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  }) {
    return Stream.fromIterable([
      const DownloadProgressEntity(
        status: DownloadStatus.downloading,
        receivedBytes: 50,
        totalBytes: 100,
      ),
      const DownloadProgressEntity(
        status: DownloadStatus.completed,
        filePath: '/data/user/0/app/updates/release.apk',
      ),
    ]);
  }

  @override
  Future<Result<bool, Failure>> installApk(String filePath) async {
    installedPath = filePath;
    return const Success(data: true);
  }
}

final class FakeDeviceInfoRepo extends DeviceInfoRepository {
  DeviceInfoEntity deviceInfo = const DeviceInfoEntity(
    deviceId: 'test-device-id',
    deviceModel: 'Pixel 7',
    osVersion: 'Android 14',
    versionCode: 100,
    versionName: '1.0.0',
  );

  @override
  Future<Result<String, Failure>> getDeviceName() async =>
      Success(data: deviceInfo.deviceModel);

  @override
  Future<Result<DeviceInfoEntity, Failure>> getDeviceInfo() async =>
      Success(data: deviceInfo);
}

final class FakeAuthRepo extends AuthenticationRepository {
  bool loggedOut = false;

  @override
  Future<void> logout() async {
    loggedOut = true;
  }

  @override
  void dispose() {}

  @override
  List<AccessibleFacilityEntity> getAccessibleFacilities() => const [];

  @override
  UserEntity? getCurrentUser() => null;

  @override
  Set<UserPermission> getPermissions() => const {};

  @override
  bool hasPermission(UserPermission permission) => false;

  @override
  Future<Result<LoginResponseEntity, Failure>> login(LoginRequestEntity data) =>
      throw UnimplementedError();

  @override
  Result<int, Failure> requireActivePartnerId() =>
      const Error(Failure.partnerUnavailable);

  @override
  Stream<UserSessionEntity?> watchSession() => const Stream.empty();

  @override
  UserSessionEntity? get currentSession => null;

  @override
  Future<Result<SignUpResponseEntity, Failure>> register(
    SignUpRequestEntity data,
  ) => throw UnimplementedError();

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
}

void main() {
  late FakeAppUpdateRepo fakeAppUpdateRepo;
  late FakeDeviceInfoRepo fakeDeviceInfoRepo;
  late FakeAuthRepo fakeAuthRepo;
  late ProviderContainer container;

  setUp(() {
    fakeAppUpdateRepo = FakeAppUpdateRepo();
    fakeDeviceInfoRepo = FakeDeviceInfoRepo();
    fakeAuthRepo = FakeAuthRepo();

    container = ProviderContainer(
      overrides: [
        checkAppVersionUseCaseProvider.overrideWithValue(
          CheckAppVersionUseCase(fakeAppUpdateRepo),
        ),
        reportAppUpdateActionUseCaseProvider.overrideWithValue(
          ReportAppUpdateActionUseCase(fakeAppUpdateRepo),
        ),
        downloadApkUseCaseProvider.overrideWithValue(
          DownloadApkUseCase(fakeAppUpdateRepo),
        ),
        installApkUseCaseProvider.overrideWithValue(
          InstallApkUseCase(fakeAppUpdateRepo),
        ),
        getDeviceInfoUseCaseProvider.overrideWithValue(
          GetDeviceInfoUseCase(fakeDeviceInfoRepo),
        ),
        logoutUseCaseProvider.overrideWithValue(
          LogoutUseCase(fakeAuthRepo),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AppUpdateNotifier', () {
    test('updates state to data when hard update is available', () async {
      const update = AppUpdateCheckResponseEntity(
        updateType: UpdateType.hard,
        installSource: InstallSource.sideload,
        eventId: 5,
        latestVersionName: '2.5.1',
        latestVersionCode: 125,
        changelog: ['Bug fixes'],
        downloadUrl: 'https://example.com/app.apk',
      );
      fakeAppUpdateRepo.checkResponse = update;

      final result = await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      final expectedUpdate = update.copyWith(
        currentVersionName: fakeDeviceInfoRepo.deviceInfo.versionName,
        currentVersionCode: fakeDeviceInfoRepo.deviceInfo.versionCode,
      );

      expect(result, expectedUpdate);
      expect(container.read(appUpdateNotifierProvider).value, expectedUpdate);
    });

    test('sets state to null when updateType is none', () async {
      const update = AppUpdateCheckResponseEntity(
        updateType: UpdateType.none,
        installSource: InstallSource.sideload,
        eventId: 5,
      );
      fakeAppUpdateRepo.checkResponse = update;

      final result = await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      expect(result, isNull);
      expect(container.read(appUpdateNotifierProvider).value, isNull);
    });

    test('fails open and sets state to null on network failure', () async {
      fakeAppUpdateRepo.checkFailure = const Failure(
        type: FailureType.network,
        message: 'No internet',
      );

      final result = await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      expect(result, isNull);
      expect(container.read(appUpdateNotifierProvider).value, isNull);
      expect(fakeAuthRepo.loggedOut, isFalse);
    });

    test('triggers logout on 401 unauthorized error', () async {
      fakeAppUpdateRepo.checkFailure = const Failure(
        type: FailureType.unauthorized,
        message: 'Unauthenticated.',
      );

      final result = await container
          .read(appUpdateNotifierProvider.notifier)
          .checkForUpdates();

      expect(result, isNull);
      expect(fakeAuthRepo.loggedOut, isTrue);
    });

    test('reports dismissed action on dismiss tap', () async {
      const update = AppUpdateCheckResponseEntity(
        updateType: UpdateType.soft,
        installSource: InstallSource.playStore,
        eventId: 42,
      );

      await container
          .read(appUpdateNotifierProvider.notifier)
          .onDismissTap(update);

      expect(fakeAppUpdateRepo.lastReportedAction?.eventId, 42);
      expect(
        fakeAppUpdateRepo.lastReportedAction?.action,
        UpdateActionType.dismissed,
      );
      expect(container.read(appUpdateNotifierProvider).value, isNull);
    });

    test('reports skipped action on skip tap', () async {
      const update = AppUpdateCheckResponseEntity(
        updateType: UpdateType.soft,
        installSource: InstallSource.playStore,
        eventId: 42,
      );

      await container
          .read(appUpdateNotifierProvider.notifier)
          .onSkipTap(update);

      expect(fakeAppUpdateRepo.lastReportedAction?.eventId, 42);
      expect(
        fakeAppUpdateRepo.lastReportedAction?.action,
        UpdateActionType.skipped,
      );
      expect(container.read(appUpdateNotifierProvider).value, isNull);
    });
  });

  group('AppUpdateDownload', () {
    test('downloads APK and triggers install upon completion', () async {
      const update = AppUpdateCheckResponseEntity(
        updateType: UpdateType.hard,
        installSource: InstallSource.sideload,
        eventId: 10,
        latestVersionName: '2.5.1',
        latestVersionCode: 125,
        downloadUrl: 'https://example.com/app.apk',
      );

      final sub = container.listen(
        appUpdateDownloadProvider,
        (previous, next) {},
      );

      await container
          .read(appUpdateDownloadProvider.notifier)
          .startDownloadAndInstall(update);

      expect(fakeAppUpdateRepo.lastReportedAction?.eventId, 10);
      expect(
        fakeAppUpdateRepo.lastReportedAction?.action,
        UpdateActionType.updated,
      );
      expect(
        fakeAppUpdateRepo.installedPath,
        '/data/user/0/app/updates/release.apk',
      );
      expect(
        container.read(appUpdateDownloadProvider).status,
        DownloadStatus.completed,
      );

      sub.close();
    });
  });
}
