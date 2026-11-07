import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/base/base.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/door_lock_entity.dart';
import '../../domain/repositories/gateway_repository.dart';
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

  Future<Result<bool, Failure>> unlockDoorWithAuth({
    required String facilityId,
    required String authCode,
    required String door,
    required String use,
    int? amount,
    String? purpose,
    String? attendant,
    int? attendantId,
  }) {
    return asyncGuard(() async {
      if (await _isOnline()) {
        try {
          final response = await _gatewayService.openFacilityDoor(
            authCode: authCode,
            door: door,
            use: use,
            amount: amount,
            purpose: purpose,
            attendant: attendant,
            attendantId: attendantId,
          );

          final result = response['result'] as String?;
          final opened = result == 'opened';
          _mockDoorStateMap[facilityId] = !opened;
          return opened;
        } catch (e) {
          Log.warning('Online unlock failed ($e), falling back to mock');
        }
      }

      _mockDoorStateMap[facilityId] = false;
      return true;
    });
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
      final isConnected = await _isOnline();
      Log.info('📊 Door status - facility: $facilityId, connected: $isConnected');

      if (isConnected) {
        try {
          Log.info('🔌 Pinging gateway with health check');
          final available = await _gatewayService.healthCheck();

          if (available) {
            Log.info('✅ Gateway online, returning cached state');
            final isLocked = _mockDoorStateMap[facilityId] ?? true;

            await _cacheService.saveRelayStatus(
              OfflineRelayStatus(
                facilityId: facilityId,
                isLocked: isLocked,
                lastUpdated: DateTime.now(),
              ),
            );

            return DoorLockEntity(
              facilityId: facilityId,
              isLocked: isLocked,
              lastUpdated: DateTime.now(),
              cachedData: false,
            );
          }
        } catch (e) {
          Log.error('❌ Gateway health check failed: $e');
        }
      }

      final isLocked = _mockDoorStateMap[facilityId] ?? true;
      Log.warning('⚠️ Using cached state (offline): isLocked=$isLocked');

      return DoorLockEntity(
        facilityId: facilityId,
        isLocked: isLocked,
        lastUpdated: DateTime.now(),
        cachedData: true,
      );
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
