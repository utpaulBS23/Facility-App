import '../../core/base/base.dart';
import '../entities/location_ping_entity.dart';

abstract base class LocationPingRepository extends Repository {
  Future<Result<void, Failure>> startTracking({required int taskId});

  Future<Result<void, Failure>> stopTracking();

  Future<Result<void, Failure>> syncCurrentLocation({required int taskId});

  Future<Result<void, Failure>> syncLocationPings({
    required int partnerId,
    required LocationPingSyncRequestEntity request,
  });
}
