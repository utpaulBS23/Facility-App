import '../../core/base/base.dart';
import '../../domain/entities/location_ping_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/location_ping_repository.dart';
import '../services/location/background_location_tracking_service.dart';
import '../services/location/location_service.dart';
import '../services/network/rest_client.dart';
import '../services/notification/location_sharing_notification_service.dart';

final class LocationPingRepositoryImpl extends LocationPingRepository {
  LocationPingRepositoryImpl({
    required RestClient remote,
    required LocationService locationService,
    required BackgroundLocationTrackingService trackingService,
    required LocationSharingNotificationService notificationService,
    required AuthenticationRepository authenticationRepository,
  }) : _remote = remote,
       _locationService = locationService,
       _trackingService = trackingService,
       _notificationService = notificationService,
       _authenticationRepository = authenticationRepository;

  static const _syncInterval = Duration(seconds: 10);

  final RestClient _remote;
  final LocationService _locationService;
  final BackgroundLocationTrackingService _trackingService;
  final LocationSharingNotificationService _notificationService;
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Result<void, Failure>> startTracking({required int taskId}) {
    return asyncGuard(() async {
      await _notificationService.showSharingNotification();
      _trackingService.start(
        interval: _syncInterval,
        fireImmediately: true,
        onTick: () async {
          await syncCurrentLocation(taskId: taskId);
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
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Unable to get current location');
      }

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
}

extension LocationPingSyncRequestMapper on LocationPingSyncRequestEntity {
  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'pings': pings.map((ping) => ping.toJson()).toList(),
    };
  }
}

extension LocationPingMapper on LocationPingEntity {
  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      'recorded_at': recordedAt.toUtc().toIso8601String(),
      if (battery != null) 'battery': battery,
    };
  }
}
