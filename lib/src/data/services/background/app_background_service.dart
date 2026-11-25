import 'dart:async';
import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../cache/cache_service.dart';
import 'background_service_entrypoint.dart';
import 'background_task_registry.dart';

/// Runs one [BackgroundTask] at a time inside a single persistent, native
/// Android service that survives the app being swiped from recents (not a
/// user-initiated "Force Stop", which the OS tears down unconditionally).
///
/// WHY one shared service, not one per feature: Android lets a plugin stand
/// up exactly one such service via `configure()`. Every feature that needs
/// this guarantee registers a [BackgroundTask] in `backgroundTaskRegistry`
/// and starts it by [BackgroundTask.id] instead of adding its own service.
abstract class AppBackgroundService {
  /// Whether a task is currently started. Backed by a persisted flag, not a
  /// live query of the native service — see the impl for why.
  bool get isRunning;

  /// The [BackgroundTask.id] currently running, or null.
  String? get activeTaskId;

  Future<void> start({
    required String taskId,
    required Map<String, dynamic> params,
  });

  Future<void> stop();
}

final class AppBackgroundServiceImpl implements AppBackgroundService {
  AppBackgroundServiceImpl(this._cache, this._notifications) {
    unawaited(_configure());
  }

  static const notificationChannelId = 'persistent_background_service';
  static const notificationChannelName = 'Background activity';

  final CacheService _cache;
  final FlutterLocalNotificationsPlugin _notifications;
  Future<void>? _configuring;

  // WHY a cached flag, not `FlutterBackgroundService().isRunning()`: that
  // call is async (a platform channel round trip), and every consumer up
  // this stack today (`LocationPingRepository.isSharingLocation`,
  // `VisitCheckIn.build()`) reads this synchronously. The flag is written
  // the moment start/stop is called and survives app restarts the same way
  // the task's own params do, so it stays correct across a process kill.
  @override
  bool get isRunning =>
      _cache.get<String>(CacheKey.backgroundServiceTaskId) != null;

  @override
  String? get activeTaskId => _cache.get<String>(CacheKey.backgroundServiceTaskId);

  Future<void> _configure() {
    return _configuring ??= Future(() async {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              notificationChannelId,
              notificationChannelName,
              description: 'Shows while a background task is active.',
              importance: Importance.low,
            ),
          );

      // WHY union every registered task's type up front: Android fixes a
      // foreground service's declared types at `configure()` time — a
      // running service cannot add one later, so whichever task starts
      // first still needs every type any task might ever request.
      final foregroundTypes = backgroundTaskRegistry.values
          .map((factory) => factory().foregroundType)
          .toSet()
          .toList();

      await FlutterBackgroundService().configure(
        iosConfiguration: IosConfiguration(autoStart: false),
        androidConfiguration: AndroidConfiguration(
          onStart: backgroundServiceEntrypoint,
          autoStart: false,
          autoStartOnBoot: false,
          isForegroundMode: true,
          notificationChannelId: notificationChannelId,
          initialNotificationTitle: 'Facility App',
          initialNotificationContent: 'Starting background task…',
          foregroundServiceTypes: foregroundTypes,
        ),
      );
    });
  }

  @override
  Future<void> start({
    required String taskId,
    required Map<String, dynamic> params,
  }) async {
    await _configure();
    await _cache.save(CacheKey.backgroundServiceTaskId, taskId);
    await _cache.save(CacheKey.backgroundServiceParams, jsonEncode(params));
    await FlutterBackgroundService().startService();
  }

  @override
  Future<void> stop() async {
    FlutterBackgroundService().invoke('stop');
    await _cache.remove([
      CacheKey.backgroundServiceTaskId,
      CacheKey.backgroundServiceParams,
    ]);
  }
}
