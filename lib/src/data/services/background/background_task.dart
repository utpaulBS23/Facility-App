import 'package:flutter_background_service/flutter_background_service.dart';

/// A unit of work that runs inside the single persistent background
/// service. Implement this to add a feature that must keep running after
/// the app is swiped from recents — location ping tracking is the first
/// consumer; anything else that needs the same guarantee registers its own
/// [BackgroundTask] instead of standing up a second native service.
abstract class BackgroundTask {
  /// Unique key this task is registered under in `backgroundTaskRegistry`
  /// and started with via [AppBackgroundService.start]. Persisted to disk,
  /// so the entrypoint can resolve the right task again after the OS killed
  /// and restarted the service with no live Dart state to carry it over.
  String get id;

  /// The Android foreground service type this task needs while running
  /// (e.g. `location`). Declared up front at `configure()` time for every
  /// registered task — Android does not let a running service add a type
  /// later, so [backgroundTaskRegistry]'s tasks are unioned once at startup.
  AndroidForegroundType get foregroundType;

  /// Runs on the background isolate — a separate Dart VM with no access to
  /// the main isolate's DI container, Riverpod state, or in-memory session.
  /// [params] is whatever [AppBackgroundService.start] was given, round
  /// tripped through disk as JSON, so keep it to primitives.
  ///
  /// WHY the task owns stopping itself: only it knows when its work is done
  /// (a one-shot sync) versus ongoing (a stream it tears down on `stop`).
  Future<void> run(ServiceInstance service, Map<String, dynamic> params);
}
