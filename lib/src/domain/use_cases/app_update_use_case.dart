import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/app_update_entity.dart';
import '../repositories/app_update_repository.dart';

final class CheckAppVersionUseCase {
  CheckAppVersionUseCase(this._repository);

  final AppUpdateRepository _repository;

  Future<Result<AppUpdateCheckResponseEntity, Failure>> call({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  }) async {
    final result = await _repository.checkVersion(
      deviceId: deviceId,
      deviceModel: deviceModel,
      osVersion: osVersion,
      currentVersionCode: currentVersionCode,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('check app version')),
    };
  }
}

final class ReportAppUpdateActionUseCase {
  ReportAppUpdateActionUseCase(this._repository);

  final AppUpdateRepository _repository;

  Future<Result<bool, Failure>> call({
    required int eventId,
    required UpdateActionType action,
  }) async {
    final request = AppUpdateActionRequestEntity(
      eventId: eventId,
      action: action,
    );

    final result = await _repository.reportUpdateAction(request);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('report update action')),
    };
  }
}

final class DownloadApkUseCase {
  DownloadApkUseCase(this._repository);

  final AppUpdateRepository _repository;

  Stream<DownloadProgressEntity> call({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  }) {
    return _repository.downloadAndVerifyApk(
      downloadUrl: downloadUrl,
      fileName: fileName,
      expectedChecksumSha256: expectedChecksumSha256,
    );
  }
}

final class InstallApkUseCase {
  InstallApkUseCase(this._repository);

  final AppUpdateRepository _repository;

  Future<Result<bool, Failure>> call(String filePath) {
    return _repository.installApk(filePath);
  }
}
