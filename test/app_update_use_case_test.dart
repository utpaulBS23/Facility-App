import 'package:facility_management_app/src/core/base/base.dart';
import 'package:facility_management_app/src/domain/entities/app_update_entity.dart';
import 'package:facility_management_app/src/domain/repositories/app_update_repository.dart';
import 'package:facility_management_app/src/domain/repositories/device_info_repository.dart';
import 'package:facility_management_app/src/domain/use_cases/app_update_use_case.dart';
import 'package:facility_management_app/src/domain/use_cases/device_info_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeAppUpdateRepository extends AppUpdateRepository {
  Future<Result<AppUpdateCheckResponseEntity, Failure>> Function({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  })? onCheckVersion;

  Future<Result<bool, Failure>> Function(AppUpdateActionRequestEntity request)?
      onReportUpdateAction;

  Stream<DownloadProgressEntity> Function({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  })? onDownloadAndVerifyApk;

  Future<Result<bool, Failure>> Function(String filePath)? onInstallApk;

  @override
  Future<Result<AppUpdateCheckResponseEntity, Failure>> checkVersion({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  }) {
    if (onCheckVersion != null) {
      return onCheckVersion!(
        deviceId: deviceId,
        deviceModel: deviceModel,
        osVersion: osVersion,
        currentVersionCode: currentVersionCode,
      );
    }
    throw UnimplementedError();
  }

  @override
  Future<Result<bool, Failure>> reportUpdateAction(
    AppUpdateActionRequestEntity request,
  ) {
    if (onReportUpdateAction != null) {
      return onReportUpdateAction!(request);
    }
    throw UnimplementedError();
  }

  @override
  Stream<DownloadProgressEntity> downloadAndVerifyApk({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  }) {
    if (onDownloadAndVerifyApk != null) {
      return onDownloadAndVerifyApk!(
        downloadUrl: downloadUrl,
        fileName: fileName,
        expectedChecksumSha256: expectedChecksumSha256,
      );
    }
    return Stream.value(
      const DownloadProgressEntity(
        status: DownloadStatus.completed,
        filePath: '/tmp/test.apk',
      ),
    );
  }

  @override
  Future<Result<bool, Failure>> installApk(String filePath) {
    if (onInstallApk != null) {
      return onInstallApk!(filePath);
    }
    return Future.value(const Success(data: true));
  }
}

final class FakeDeviceInfoRepository extends DeviceInfoRepository {
  Future<Result<String, Failure>> Function()? onGetDeviceName;
  Future<Result<DeviceInfoEntity, Failure>> Function()? onGetDeviceInfo;

  @override
  Future<Result<String, Failure>> getDeviceName() {
    if (onGetDeviceName != null) return onGetDeviceName!();
    throw UnimplementedError();
  }

  @override
  Future<Result<DeviceInfoEntity, Failure>> getDeviceInfo() {
    if (onGetDeviceInfo != null) return onGetDeviceInfo!();
    throw UnimplementedError();
  }
}

void main() {
  late FakeAppUpdateRepository updateRepository;
  late FakeDeviceInfoRepository deviceInfoRepository;

  setUp(() {
    updateRepository = FakeAppUpdateRepository();
    deviceInfoRepository = FakeDeviceInfoRepository();
  });

  group('CheckAppVersionUseCase', () {
    test('returns Success when update check succeeds', () async {
      const expectedEntity = AppUpdateCheckResponseEntity(
        updateType: UpdateType.hard,
        installSource: InstallSource.sideload,
        eventId: 10,
        latestVersionName: '2.5.1',
        latestVersionCode: 125,
      );

      updateRepository.onCheckVersion = ({
        required deviceId,
        deviceModel,
        osVersion,
        required currentVersionCode,
      }) async {
        expect(deviceId, 'device_123');
        expect(currentVersionCode, 100);
        return const Success(data: expectedEntity);
      };

      final useCase = CheckAppVersionUseCase(updateRepository);
      final result = await useCase.call(
        deviceId: 'device_123',
        deviceModel: 'Pixel 7',
        osVersion: 'Android 14',
        currentVersionCode: 100,
      );

      expect(
        result,
        const Success<AppUpdateCheckResponseEntity, Failure>(
          data: expectedEntity,
        ),
      );
    });

    test('returns Error when update check fails', () async {
      const failure = Failure(
        type: FailureType.network,
        message: 'No connection',
      );

      updateRepository.onCheckVersion = ({
        required deviceId,
        deviceModel,
        osVersion,
        required currentVersionCode,
      }) async => const Error(failure);

      final useCase = CheckAppVersionUseCase(updateRepository);
      final result = await useCase.call(
        deviceId: 'device_123',
        currentVersionCode: 100,
      );

      expect(
        result,
        const Error<AppUpdateCheckResponseEntity, Failure>(failure),
      );
    });
  });

  group('ReportAppUpdateActionUseCase', () {
    test('returns Success when action report succeeds', () async {
      updateRepository.onReportUpdateAction = (request) async {
        expect(request.eventId, 10);
        expect(request.action, UpdateActionType.updated);
        return const Success(data: true);
      };

      final useCase = ReportAppUpdateActionUseCase(updateRepository);
      final result = await useCase.call(
        eventId: 10,
        action: UpdateActionType.updated,
      );

      expect(result, const Success<bool, Failure>(data: true));
    });
  });

  group('DownloadApkUseCase', () {
    test('emits download progress events from repository', () async {
      updateRepository.onDownloadAndVerifyApk = ({
        required downloadUrl,
        required fileName,
        expectedChecksumSha256,
      }) {
        return Stream.fromIterable([
          const DownloadProgressEntity(status: DownloadStatus.downloading, receivedBytes: 50, totalBytes: 100),
          const DownloadProgressEntity(status: DownloadStatus.completed, filePath: '/path/to/apk'),
        ]);
      };

      final useCase = DownloadApkUseCase(updateRepository);
      final stream = useCase.call(
        downloadUrl: 'https://example.com/app.apk',
        fileName: 'app.apk',
      );

      final events = await stream.toList();
      expect(events.length, 2);
      expect(events[0].status, DownloadStatus.downloading);
      expect(events[0].progressPercent, 50);
      expect(events[1].status, DownloadStatus.completed);
      expect(events[1].filePath, '/path/to/apk');
    });
  });

  group('InstallApkUseCase', () {
    test('returns Success when install succeeds', () async {
      updateRepository.onInstallApk = (path) async {
        expect(path, '/path/to/apk');
        return const Success(data: true);
      };

      final useCase = InstallApkUseCase(updateRepository);
      final result = await useCase.call('/path/to/apk');

      expect(result, const Success<bool, Failure>(data: true));
    });
  });

  group('GetDeviceInfoUseCase', () {
    test('returns DeviceInfoEntity on success', () async {
      const deviceInfo = DeviceInfoEntity(
        deviceId: 'dev_abc',
        deviceModel: 'Pixel 7',
        osVersion: 'Android 14',
        versionCode: 120,
        versionName: '2.4.0',
      );

      deviceInfoRepository.onGetDeviceInfo =
          () async => const Success(data: deviceInfo);

      final useCase = GetDeviceInfoUseCase(deviceInfoRepository);
      final result = await useCase.call();

      expect(result, const Success<DeviceInfoEntity, Failure>(data: deviceInfo));
    });
  });
}
