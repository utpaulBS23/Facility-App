import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../features/notification/riverpod/app_notifications_provider.dart';

part 'push_lifecycle_provider.g.dart';

/// Keeps this device's push setup in step with the signed-in session: it
/// registers the device, follows token changes and incoming pushes, and keeps
/// the inbox and topics fresh.
///
/// A push tap only opens the notifications list, since the API gives nothing
/// to navigate to; the screen that owns navigation passes that in.
@Riverpod(keepAlive: true)
class PushLifecycle extends _$PushLifecycle {
  final _subscriptions = <StreamSubscription<Object?>>[];

  @override
  void build() {
    ref.onDispose(stop);
  }

  /// Starts once per signed-in launch; calling it again does nothing until
  /// [stop]. [onOpenNotifications] runs when the user taps a push.
  ///
  /// Returns true when a push launched the app from the terminated state, so
  /// the caller can open the list once its first frame is up.
  bool start({required void Function() onOpenNotifications}) {
    if (_subscriptions.isNotEmpty) return false;

    unawaited(ref.read(registerDeviceTokenUseCaseProvider).call());

    _subscriptions
      ..add(
        ref
            .read(watchPushTokenRefreshUseCaseProvider)
            .call()
            .listen(
              (token) => ref
                  .read(registerDeviceTokenUseCaseProvider)
                  .call(token: token),
            ),
      )
      ..add(
        ref
            .read(watchReceivedPushUseCaseProvider)
            .call()
            .listen((_) => ref.read(appNotificationsProvider.notifier).refresh()),
      )
      ..add(
        ref
            .read(getNotificationPayloadStreamUseCaseProvider)
            .call()
            .listen((_) => onOpenNotifications()),
      );

    return ref.read(getNotificationPayloadUseCaseProvider).call() != null;
  }

  /// Pushes that arrived in the background never reached the app, so look for
  /// them, and renew the topics when they are due.
  void onResumed() {
    ref.read(appNotificationsProvider.notifier).refresh();
    unawaited(ref.read(syncDeviceTopicsUseCaseProvider).call());
  }

  void stop() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
