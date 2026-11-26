import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/cache_service.dart';
import 'background_task_registry.dart';

/// The single entrypoint Android relaunches on the background isolate,
/// including after the OS kills and restarts the service with no live
/// Dart state. It reads back which [BackgroundTask] was active and its
/// params straight from disk (not through [CacheService]/Riverpod — this
/// isolate has none of that set up) and hands off to it.
@pragma('vm:entry-point')
void backgroundServiceEntrypoint(ServiceInstance service) {
  // WHY: registers this isolate's own copy of every plugin (geolocator,
  // battery_plus, secure storage, ...) — without it, plugin calls made from
  // here throw MissingPluginException.
  DartPluginRegistrant.ensureInitialized();

  unawaited(_dispatch(service));
}

Future<void> _dispatch(ServiceInstance service) async {
  final prefs = await SharedPreferences.getInstance();
  final taskId = prefs.getString(CacheKey.backgroundServiceTaskId.name);
  if (taskId == null) {
    await service.stopSelf();
    return;
  }

  final task = backgroundTaskRegistry[taskId]?.call();
  if (task == null) {
    await service.stopSelf();
    return;
  }

  final rawParams = prefs.getString(CacheKey.backgroundServiceParams.name);
  final params = rawParams == null
      ? const <String, dynamic>{}
      : jsonDecode(rawParams) as Map<String, dynamic>;

  await task.run(service, params);
}
