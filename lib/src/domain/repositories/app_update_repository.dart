import '../../core/base/base.dart';
import '../entities/app_update_entity.dart';

abstract base class AppUpdateRepository extends Repository {
  /// Queries backend to check whether an app update is available.
  Future<Result<AppUpdateCheckResponseEntity, Failure>> checkVersion({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  });

  /// Reports user update interaction (updated, skipped, dismissed) to the backend.
  Future<Result<bool, Failure>> reportUpdateAction(
    AppUpdateActionRequestEntity request,
  );

  /// Downloads the APK file in-app and streams progress, verifying SHA256 when complete.
  Stream<DownloadProgressEntity> downloadAndVerifyApk({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  });

  /// Opens the downloaded APK file with the system package installer.
  Future<Result<bool, Failure>> installApk(String filePath);
}
