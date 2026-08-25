import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';
import '../../../../domain/entities/app_update_entity.dart';
import '../../../core/application_state/reset_repositories.dart';

part 'app_update_provider.g.dart';

@riverpod
class AppUpdateNotifier extends _$AppUpdateNotifier {
  @override
  AsyncValue<AppUpdateCheckResponseEntity?> build() {
    return const AsyncValue.data(null);
  }

  /// Checks the backend for available updates.
  ///
  /// Network and 5xx errors fail open (user can proceed).
  /// 401 errors trigger session logout (device token was revoked).
  Future<AppUpdateCheckResponseEntity?> checkForUpdates() async {
    state = const AsyncValue.loading();

    final deviceInfoResult =
        await ref.read(getDeviceInfoUseCaseProvider).call();

    final deviceInfo = switch (deviceInfoResult) {
      Success(:final data) => data,
      _ => null,
    };

    if (deviceInfo == null) {
      Log.warning('AppUpdate: Could not resolve device info. Failing open.');
      state = const AsyncValue.data(null);
      return null;
    }

    final result = await ref.read(checkAppVersionUseCaseProvider).call(
      deviceId: deviceInfo.deviceId,
      deviceModel: deviceInfo.deviceModel,
      osVersion: deviceInfo.osVersion,
      currentVersionCode: deviceInfo.versionCode,
    );

    return switch (result) {
      Success(:final data) when data != null => _handleSuccess(
        data.copyWith(
          currentVersionName: deviceInfo.versionName,
          currentVersionCode: deviceInfo.versionCode,
        ),
      ),
      Error(:final error) => _handleError(error),
      _ => _failOpen('Unexpected version check response'),
    };
  }

  AppUpdateCheckResponseEntity? _handleSuccess(
    AppUpdateCheckResponseEntity response,
  ) {
    if (!response.hasUpdate) {
      state = const AsyncValue.data(null);
      return null;
    }

    state = AsyncValue.data(response);
    return response;
  }

  AppUpdateCheckResponseEntity? _handleError(Failure failure) {
    // 401 means token revoked (e.g. single-device enforcement or admin deactivation).
    if (failure.type == FailureType.unauthorized) {
      Log.warning(
        'AppUpdate: Received 401 Unauthorized during version check. Clearing session.',
      );
      ref.read(logoutUseCaseProvider).call();
      // Invalidate all repository providers, matching LogoutProvider's flow —
      // otherwise cached session-scoped data survives this forced logout.
      resetRepositories(ref);
      state = const AsyncValue.data(null);
      return null;
    }

    // Fail open on network errors, timeouts, or server errors per API spec.
    return _failOpen('AppUpdate check failed: ${failure.message}');
  }

  AppUpdateCheckResponseEntity? _failOpen(String reason) {
    Log.info('AppUpdate: $reason. Failing open to allow user access.');
    state = const AsyncValue.data(null);
    return null;
  }

  /// Triggered immediately on tap of "Update Now".
  /// Reports intent to backend before launching store/download URL.
  Future<void> onUpdateNowTap(AppUpdateCheckResponseEntity update) async {
    // Fire and forget action report per API doc §2.2
    ref.read(reportAppUpdateActionUseCaseProvider).call(
      eventId: update.eventId,
      action: UpdateActionType.updated,
    );

    final urlString = update.updateUrl;
    if (urlString == null || urlString.isEmpty) {
      Log.error('AppUpdate: No update URL provided for ${update.installSource}');
      return;
    }

    final uri = Uri.tryParse(urlString);
    if (uri == null) {
      Log.error('AppUpdate: Invalid update URL: $urlString');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        Log.warning(
          'AppUpdate: externalApplication launch returned false, attempting platformDefault',
        );
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Log.warning(
        'AppUpdate: externalApplication launch error: $e, attempting platformDefault',
      );
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (fallbackError) {
        Log.error('AppUpdate: Could not launch $urlString: $fallbackError');
      }
    }
  }

  /// Triggered when user dismisses a soft update.
  Future<void> onDismissTap(AppUpdateCheckResponseEntity update) async {
    ref.read(reportAppUpdateActionUseCaseProvider).call(
      eventId: update.eventId,
      action: UpdateActionType.dismissed,
    );
    state = const AsyncValue.data(null);
  }

  /// Triggered when user skips a soft update.
  Future<void> onSkipTap(AppUpdateCheckResponseEntity update) async {
    ref.read(reportAppUpdateActionUseCaseProvider).call(
      eventId: update.eventId,
      action: UpdateActionType.skipped,
    );
    state = const AsyncValue.data(null);
  }
}
