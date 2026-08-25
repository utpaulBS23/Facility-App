import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/base/base.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/app_update_entity.dart';
import '../../domain/repositories/app_update_repository.dart';
import '../extension/app_update_mapper.dart';
import '../models/app_update_model.dart';
import '../services/network/rest_client.dart';

final class AppUpdateRepositoryImpl extends AppUpdateRepository {
  AppUpdateRepositoryImpl(this._remote, this._dio);

  final RestClient _remote;
  final Dio _dio;

  @override
  Future<Result<AppUpdateCheckResponseEntity, Failure>> checkVersion({
    required String deviceId,
    String? deviceModel,
    String? osVersion,
    required int currentVersionCode,
  }) {
    return asyncGuard(() async {
      final response = await _remote.checkVersion(
        deviceId: deviceId,
        deviceModel: deviceModel,
        osVersion: osVersion,
        currentVersionCode: currentVersionCode,
      );

      final model = AppUpdateCheckResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return model.toEntity();
    });
  }

  @override
  Future<Result<bool, Failure>> reportUpdateAction(
    AppUpdateActionRequestEntity request,
  ) {
    return asyncGuard(() async {
      final model = request.toModel();
      await _remote.reportUpdateAction(request: model.toJson());
      return true;
    });
  }

  @override
  Stream<DownloadProgressEntity> downloadAndVerifyApk({
    required String downloadUrl,
    required String fileName,
    String? expectedChecksumSha256,
  }) {
    final controller = StreamController<DownloadProgressEntity>();

    () async {
      try {
        controller.add(
          const DownloadProgressEntity(status: DownloadStatus.downloading),
        );

        final tempDir = await getTemporaryDirectory();
        final updatesDir = Directory('${tempDir.path}/updates');
        if (!await updatesDir.exists()) {
          await updatesDir.create(recursive: true);
        }

        final filePath = '${updatesDir.path}/$fileName';
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }

        await _dio.download(
          downloadUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (!controller.isClosed) {
              controller.add(
                DownloadProgressEntity(
                  status: DownloadStatus.downloading,
                  receivedBytes: received,
                  totalBytes: total,
                  filePath: filePath,
                ),
              );
            }
          },
        );

        if (!controller.isClosed) {
          controller.add(
            DownloadProgressEntity(
              status: DownloadStatus.verifying,
              filePath: filePath,
            ),
          );
        }

        if (expectedChecksumSha256 != null &&
            expectedChecksumSha256.isNotEmpty) {
          final bytes = await file.readAsBytes();
          final actualHash = sha256.convert(bytes).toString();
          if (actualHash.toLowerCase() !=
              expectedChecksumSha256.toLowerCase()) {
            Log.error(
              'AppUpdate: Checksum mismatch! Expected: $expectedChecksumSha256, Actual: $actualHash',
            );
            if (!controller.isClosed) {
              controller.add(
                const DownloadProgressEntity(
                  status: DownloadStatus.error,
                  errorMessage: 'Checksum verification failed',
                ),
              );
            }
            await controller.close();
            return;
          }
        }

        if (!controller.isClosed) {
          controller.add(
            DownloadProgressEntity(
              status: DownloadStatus.completed,
              filePath: filePath,
            ),
          );
        }
      } catch (e, stackTrace) {
        Log.error('AppUpdate download failed: $e\n$stackTrace');
        if (!controller.isClosed) {
          controller.add(
            DownloadProgressEntity(
              status: DownloadStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return controller.stream;
  }

  @override
  Future<Result<bool, Failure>> installApk(String filePath) {
    return asyncGuard(() async {
      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );
      if (result.type != ResultType.done) {
        Log.warning('OpenFilex returned: ${result.type} - ${result.message}');
      }
      return result.type == ResultType.done;
    });
  }
}
