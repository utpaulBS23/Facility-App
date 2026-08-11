import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/base/base.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/door_lock_entity.dart';
import '../../domain/repositories/gateway_repository.dart';
import '../extension/door_access_mapper.dart';
import '../mock/door_access_mock_data.dart';
import '../services/cache/offline_cache_service.dart';
import '../services/gateway/gateway_config.dart';
import '../services/gateway/gateway_service.dart';

/// Implements [GatewayRepository] attempting network calls first, falling back
/// seamlessly to local mock data (with `cachedData: true`) if unreachable.
final class GatewayRepositoryImpl extends GatewayRepository {
  GatewayRepositoryImpl(
    this._gatewayService,
    this._cacheService,
    this._connectivity,
  );

  final GatewayService _gatewayService;
  final OfflineCacheService _cacheService;
  final Connectivity _connectivity;

  static final Map<String, bool> _mockDoorStateMap = {};

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
  Future<Result<bool, Failure>> unlockDoor(String facilityId) {
    return asyncGuard(() async {
      final relay = GatewayConfig.relayForFacility(facilityId);

      if (await _isOnline()) {
        try {
          final success = await _gatewayService.controlRelay(
            relayNumber: relay,
            unlock: true,
          );
          _mockDoorStateMap[facilityId] = false;
          return success;
        } catch (e) {
          Log.warning('Online unlock failed ($e), falling back to mock');
        }
      }

      _mockDoorStateMap[facilityId] = false;
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> lockDoor(String facilityId) {
    return asyncGuard(() async {
      final relay = GatewayConfig.relayForFacility(facilityId);

      if (await _isOnline()) {
        try {
          final success = await _gatewayService.controlRelay(
            relayNumber: relay,
            unlock: false,
          );
          _mockDoorStateMap[facilityId] = true;
          return success;
        } catch (e) {
          Log.warning('Online lock failed ($e), falling back to mock');
        }
      }

      _mockDoorStateMap[facilityId] = true;
      return true;
    });
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
            cachedData: false,
          );
        } catch (e) {
          Log.warning('Network gateway call failed ($e), falling back to mock data');
        }
      }

      // Fallback to mock data with offline cachedData flag set to true
      final isLocked = _mockDoorStateMap[facilityId] ?? true;
      final model = DoorAccessMockData.createMockModel(
        facilityId: facilityId,
        isLocked: isLocked,
      );

      return model.toEntity().copyWith(cachedData: true);
    });
  }

  @override
  Future<Result<bool, Failure>> isGatewayAvailable() {
    return asyncGuard(() async {
      if (!await _isOnline()) return false;
      return _gatewayService.healthCheck();
    });
  }
}
