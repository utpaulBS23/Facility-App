import '../location/location_ping_background_task.dart';
import 'background_task.dart';

/// Every [BackgroundTask] the persistent background service can dispatch
/// to, keyed by [BackgroundTask.id].
///
/// WHY a plain map, not DI: `backgroundServiceEntrypoint` runs on a fresh
/// background isolate with no ProviderContainer and no widget tree, so
/// every task reachable from it must be constructible with zero
/// dependencies and registered here by hand. Add a new feature's task by
/// listing its constructor alongside the existing ones.
final Map<String, BackgroundTask Function()> backgroundTaskRegistry = {
  LocationPingBackgroundTask.taskId: LocationPingBackgroundTask.new,
};
