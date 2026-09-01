import '../../core/base/base.dart';
import '../entities/location_ping_entity.dart';

abstract base class LocationPingRepository extends Repository {
  /// Whether background location tracking is currently active.
  bool get isSharingLocation;

  /// The visit ([startTracking]'s `taskId`) currently being tracked for,
  /// or null when [isSharingLocation] is false.
  int? get activeTaskId;

  Future<Result<void, Failure>> startTracking({required int taskId});

  Future<Result<void, Failure>> stopTracking();

  Future<Result<void, Failure>> syncCurrentLocation({required int taskId});

  Future<Result<void, Failure>> syncLocationPings({
    required int partnerId,
    required LocationPingSyncRequestEntity request,
  });
}
