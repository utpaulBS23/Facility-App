import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';
import '../../../../domain/entities/app_update_entity.dart';

part 'app_update_download_provider.g.dart';

@riverpod
class AppUpdateDownload extends _$AppUpdateDownload {
  StreamSubscription<DownloadProgressEntity>? _subscription;

  @override
  DownloadProgressEntity build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const DownloadProgressEntity();
  }

  /// Initiates download & auto-install for sideload updates, or store launch for play_store.
  Future<void> startDownloadAndInstall(
    AppUpdateCheckResponseEntity update,
  ) async {
    // 1. Report update action to backend per API doc §2.2
    ref.read(reportAppUpdateActionUseCaseProvider).call(
      eventId: update.eventId,
      action: UpdateActionType.updated,
    );

    // 2. If Play Store source, launch external store URL
    if (update.installSource == InstallSource.playStore) {
      await _launchStoreUrl(update);
      return;
    }

    // 3. For Sideload: Download in-app and trigger package installer
    final downloadUrl = update.downloadUrl ?? update.updateUrl;
    if (downloadUrl == null || downloadUrl.isEmpty) {
      Log.error('AppUpdateDownload: No download URL available.');
      state = const DownloadProgressEntity(
        status: DownloadStatus.error,
        errorMessage: 'Download URL is missing',
      );
      return;
    }

    final versionName = update.latestVersionName ?? 'update';
    final fileName = 'release-$versionName.apk';

    await _subscription?.cancel();

    state = const DownloadProgressEntity(status: DownloadStatus.downloading);

    final stream = ref.read(downloadApkUseCaseProvider).call(
      downloadUrl: downloadUrl,
      fileName: fileName,
      expectedChecksumSha256: update.checksumSha256,
    );

    final completer = Completer<void>();

    _subscription = stream.listen(
      (progress) async {
        state = progress;

        if (progress.status == DownloadStatus.completed &&
            progress.filePath != null) {
          Log.info('AppUpdateDownload: Completed. Triggering installer...');
          await _installApk(progress.filePath!);
          if (!completer.isCompleted) completer.complete();
        } else if (progress.status == DownloadStatus.error) {
          if (!completer.isCompleted) completer.complete();
        }
      },
      onError: (Object error) {
        Log.error('AppUpdateDownload: Stream error: $error');
        state = DownloadProgressEntity(
          status: DownloadStatus.error,
          errorMessage: error.toString(),
        );
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future;
  }

  Future<void> _installApk(String filePath) async {
    final result = await ref.read(installApkUseCaseProvider).call(filePath);
    switch (result) {
      case Success():
        Log.info('AppUpdateDownload: Installer opened successfully.');
      case Error(:final error):
        Log.error('AppUpdateDownload: Install error: $error');
      case _:
        break;
    }
  }

  Future<void> _launchStoreUrl(AppUpdateCheckResponseEntity update) async {
    final urlString = update.storeUrl ?? update.updateUrl;
    if (urlString == null || urlString.isEmpty) {
      Log.error('AppUpdateDownload: No store URL provided');
      return;
    }

    final uri = Uri.tryParse(urlString);
    if (uri == null) {
      Log.error('AppUpdateDownload: Invalid store URL: $urlString');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Log.warning('AppUpdateDownload: Launch error: $e');
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }

  void reset() {
    _subscription?.cancel();
    state = const DownloadProgressEntity();
  }
}
