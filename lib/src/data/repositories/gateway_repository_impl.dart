import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/base/base.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/door_lock_entity.dart';
import '../../domain/repositories/gateway_repository.dart';
import '../services/cache/offline_cache_service.dart';
import '../services/gateway/gateway_config.dart';
import '../services/gateway/gateway_service.dart';

/// Combines the live gateway API with an offline cache: a lock/unlock
/// command still succeeds (optimistically, queued for later sync) when the
/// device can't reach the gateway, and status reads fall back to the last
/// known state.
final class GatewayRepositoryImpl extends GatewayRepository {
  GatewayRepositoryImpl(
    this._gatewayService,
    this._cacheService,
    this._connectivity,
  );

  final GatewayService _gatewayService;
  final OfflineCacheService _cacheService;
  final Connectivity _connectivity;

  Future<bool> _isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      Log.error('Connectivity check error: $e');
      return false;
    }
  }

  @override
  Future<Result<bool, Failure>> unlockDoor(String facilityId) =>
      _setLock(facilityId, unlock: true);

  @override
  Future<Result<bool, Failure>> lockDoor(String facilityId) =>
      _setLock(facilityId, unlock: false);

  Future<Result<bool, Failure>> _setLock(
    String facilityId, {
    required bool unlock,
  }) {
    return asyncGuard(() async {
      final relay = GatewayConfig.relayForFacility(facilityId);

      if (await _isOnline()) {
        try {
          final success = await _gatewayService.controlRelay(
            relayNumber: relay,
            unlock: unlock,
          );
          await _cacheService.saveRelayStatus(
            OfflineRelayStatus(
              facilityId: facilityId,
              isLocked: !unlock,
              lastUpdated: DateTime.now(),
            ),
          );
          return success;
        } on GatewayException catch (e) {
          Log.error(
            'Online ${unlock ? 'unlock' : 'lock'} failed: $e, queuing offline',
          );
          return _queueOffline(facilityId, unlock: unlock);
        }
      }

      return _queueOffline(facilityId, unlock: unlock);
    });
  }

  Future<bool> _queueOffline(String facilityId, {required bool unlock}) async {
    await _cacheService.queueCommand(
      OfflineDoorCommand(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        facilityId: facilityId,
        unlock: unlock,
        timestamp: DateTime.now(),
      ),
    );
    // WHY optimistic: the command is queued for sync, and the physical relay
    // will follow once it does — the UI reflects the requested state now
    // rather than blocking the staff member on gateway connectivity.
    return true;
  }

  @override
  Future<Result<DoorLockEntity, Failure>> getDoorStatus(String facilityId) {
    return asyncGuard(() async {
      final relay = GatewayConfig.relayForFacility(facilityId);

      if (await _isOnline()) {
        try {
          final status = await _gatewayService.getRelayStatus();
          final relays = status['relays'] as Map<String, dynamic>? ?? {};
          final isUnlocked = relays['$relay'] == true;

          await _cacheService.saveRelayStatus(
            OfflineRelayStatus(
              facilityId: facilityId,
              isLocked: !isUnlocked,
              lastUpdated: DateTime.now(),
            ),
          );

          return DoorLockEntity(
            facilityId: facilityId,
            isLocked: !isUnlocked,
            lastUpdated: DateTime.now(),
          );
        } on GatewayException catch (e) {
          Log.error('Online status check failed: $e, using cached data');
          return _cachedStatus(facilityId);
        }
      }

      return _cachedStatus(facilityId);
    });
  }

  DoorLockEntity _cachedStatus(String facilityId) {
    final cached = _cacheService.getRelayStatus(facilityId);
    if (cached == null) {
      return DoorLockEntity(
        facilityId: facilityId,
        isLocked: true,
        lastUpdated: DateTime.now(),
        cachedData: true,
      );
    }
    return DoorLockEntity(
      facilityId: facilityId,
      isLocked: cached.isLocked,
      lastUpdated: cached.lastUpdated,
      cachedData: true,
      syncPending: _cacheService.getPendingCommands().any(
        (c) => c.facilityId == facilityId,
      ),
    );
  }

  @override
  Future<Result<bool, Failure>> isGatewayAvailable() {
    return asyncGuard(() async {
      if (!await _isOnline()) return false;
      return _gatewayService.healthCheck();
    });
  }
}
