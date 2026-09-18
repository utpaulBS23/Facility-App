import '../../core/base/base.dart';
import '../entities/door_lock_entity.dart';

/// Controls a facility's physical door lock through its local gateway
/// device, with an offline-queued fallback when the gateway is unreachable.
abstract base class GatewayRepository extends Repository {
  Future<Result<bool, Failure>> unlockDoor(String facilityId);

  Future<Result<bool, Failure>> lockDoor(String facilityId);

  Future<Result<DoorLockEntity, Failure>> getDoorStatus(String facilityId);

  Future<Result<bool, Failure>> isGatewayAvailable();
}
