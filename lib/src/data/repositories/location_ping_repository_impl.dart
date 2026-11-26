import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/base/base.dart';
import '../../core/logger/log.dart';
import '../../domain/entities/location_ping_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/location_ping_repository.dart';
import '../extension/location_ping_mapper.dart';
import '../services/background/app_background_service.dart';
import '../services/cache/cache_service.dart';
import '../services/location/location_ping_background_task.dart';
import '../services/network/rest_client.dart';

final class LocationPingRepositoryImpl extends LocationPingRepository {
  LocationPingRepositoryImpl({
    required RestClient remote,
    required AppBackgroundService backgroundService,
    required CacheService cache,
    required AuthenticationRepository authenticationRepository,
  }) : _remote = remote,
       _backgroundService = backgroundService,
       _cache = cache,
       _authenticationRepository = authenticationRepository;

  final RestClient _remote;
  final AppBackgroundService _backgroundService;
  final CacheService _cache;
  final AuthenticationRepository _authenticationRepository;
  final Battery _battery = Battery();

  // WHY delegate to the background service, not a separate bool: it is
  // already the single source of truth for whether the tracking task is
  // running — a second flag here could drift out of sync with it.
  @override
  bool get isSharingLocation =>
      _backgroundService.isRunning &&
      _backgroundService.activeTaskId == LocationPingBackgroundTask.taskId;

  @override
  int? get activeTaskId =>
      isSharingLocation ? _cache.get<int>(CacheKey.locationPingActiveVisitId) : null;

  @override
  Future<Result<void, Failure>> startTracking({required int taskId}) {
    return asyncGuard(() async {
      final activeVisitIntervalSeconds = _authenticationRepository
          .currentSession
          ?.trackingSettings
          ?.activeVisitPingIntervalSeconds;
      if (activeVisitIntervalSeconds == null) {
        throw Exception(
          'Tracking interval not configured for this session.',
        );
      }

      await _ensureTrackingPermission();
      await _cache.save(CacheKey.locationPingActiveVisitId, taskId);
      await _backgroundService.start(
        taskId: LocationPingBackgroundTask.taskId,
        params: {'taskId': taskId, 'intervalSeconds': activeVisitIntervalSeconds},
      );
    });
  }

  @override
  Future<Result<void, Failure>> stopTracking() {
    return asyncGuard(() async {
      await _backgroundService.stop();
      await _cache.remove([CacheKey.locationPingActiveVisitId]);
    });
  }

  @override
  Future<Result<void, Failure>> syncCurrentLocation({
    required int taskId,
  }) async {
    final partnerId = _authenticationRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final requestResult = await asyncGuard(() async {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return _requestFromPosition(taskId: taskId, position: position);
    });

    return switch (requestResult) {
      Success(:final data) when data != null => syncLocationPings(
        partnerId: partnerId,
        request: data,
      ),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('build location ping request')),
    };
  }

  Future<Result<void, Failure>> syncPosition({
    required int taskId,
    required Position position,
  }) async {
    final partnerId = _authenticationRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final requestResult = asyncGuard(() async {
      return _requestFromPosition(taskId: taskId, position: position);
    });

    return switch (await requestResult) {
      Success(:final data) when data != null => syncLocationPings(
        partnerId: partnerId,
        request: data,
      ),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('build location ping request')),
    };
  }

  Future<LocationPingSyncRequestEntity> _requestFromPosition({
    required int taskId,
    required Position position,
  }) async {
    if (position.isMocked) {
      throw Exception('You are using a mocked location');
    }

    // WHY best-effort: battery level is a nice-to-have for ops visibility,
    // not something a ping should ever fail over — omit it rather than
    // block/throw when the platform can't report it.
    int? battery;
    try {
      battery = await _battery.batteryLevel;
    } catch (e) {
      Log.error('battery level unavailable: $e');
      battery = null;
    }

    return LocationPingSyncRequestEntity(
      taskId: taskId,
      pings: [
        LocationPingEntity(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          recordedAt: DateTime.now().toUtc(),
          battery: battery,
        ),
      ],
    );
  }

  @override
  Future<Result<void, Failure>> syncLocationPings({
    required int partnerId,
    required LocationPingSyncRequestEntity request,
  }) {
    return asyncGuard(() async {
      await _remote.syncLocationPings(
        partnerId: partnerId,
        request: request.toJson(),
      );
    });
  }

  Future<void> _ensureTrackingPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.unableToDetermine) {
      throw Exception('Unable to determine location permission');
    }

    if (permission != LocationPermission.always) {
      await Geolocator.openLocationSettings();
      throw Exception('Background location permission is required. Enable "Allow all the time" in settings.');
    }
  }
}
