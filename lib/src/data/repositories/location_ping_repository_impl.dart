import 'package:geolocator/geolocator.dart';

import '../../core/base/base.dart';
import '../../domain/entities/location_ping_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/location_ping_repository.dart';
import '../extension/location_ping_mapper.dart';
import '../services/location/background_location_tracking_service.dart';
import '../services/network/rest_client.dart';
import '../services/notification/location_sharing_notification_service.dart';

final class LocationPingRepositoryImpl extends LocationPingRepository {
  LocationPingRepositoryImpl({
    required RestClient remote,
    required BackgroundLocationTrackingService trackingService,
    required LocationSharingNotificationService notificationService,
    required AuthenticationRepository authenticationRepository,
  }) : _remote = remote,
       _trackingService = trackingService,
       _notificationService = notificationService,
       _authenticationRepository = authenticationRepository;

  // WHY fallback: used only if a session was restored without
  // tracking_settings (e.g. payload persisted before this field existed).
  static const _defaultSyncInterval = Duration(seconds: 10);

  final RestClient _remote;
  final BackgroundLocationTrackingService _trackingService;
  final LocationSharingNotificationService _notificationService;
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Result<void, Failure>> startTracking({required int taskId}) {
    return asyncGuard(() async {
      await _ensureTrackingPermission();
      await _notificationService.showSharingNotification();
      final activeVisitIntervalSeconds = _authenticationRepository
          .currentSession
          ?.trackingSettings
          ?.activeVisitPingIntervalSeconds;
      _trackingService.start(
        interval: activeVisitIntervalSeconds == null
            ? _defaultSyncInterval
            : Duration(seconds: activeVisitIntervalSeconds),
        fireImmediately: true,
        onPosition: (position) async {
          await syncPosition(taskId: taskId, position: position);
        },
      );
    });
  }

  @override
  Future<Result<void, Failure>> stopTracking() {
    return asyncGuard(() async {
      _trackingService.stop();
      await _notificationService.hideSharingNotification();
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

  LocationPingSyncRequestEntity _requestFromPosition({
    required int taskId,
    required Position position,
  }) {
    if (position.isMocked) {
      throw Exception('You are using a mocked location');
    }

    return LocationPingSyncRequestEntity(
      taskId: taskId,
      pings: [
        LocationPingEntity(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          recordedAt: DateTime.now().toUtc(),
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
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    if (permission != LocationPermission.always) {
      await Geolocator.openAppSettings();
      throw Exception('Background location permission is required');
    }
  }
}
