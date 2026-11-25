import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/config/app_config.dart';
import '../../../core/logger/log.dart';
import '../../../domain/entities/location_ping_entity.dart';
import '../background/background_task.dart';
import '../../extension/location_ping_mapper.dart';
import '../../models/login_model.dart';
import '../../extension/auth_mapper.dart';
import '../network/endpoints.dart';
import '../network/rest_client.dart';
import '../secure_storage/secure_storage_service.dart';

/// Keeps pinging the visit's location while it runs, surviving the app
/// being swiped from recents — dispatched by `backgroundServiceEntrypoint`
/// via [AppBackgroundService], not started directly.
///
/// WHY it builds its own [RestClient]/[Dio]: this runs on the background
/// isolate, a separate Dart VM with no access to the main isolate's DI
/// container, Riverpod state, or in-memory [SessionService] — the access
/// token and partner id are read straight from the same secure-storage
/// session payload [AuthenticationRepositoryImpl] persists on login.
final class LocationPingBackgroundTask implements BackgroundTask {
  static const taskId = 'location_ping_tracking';

  @override
  String get id => taskId;

  @override
  AndroidForegroundType get foregroundType => AndroidForegroundType.location;

  StreamSubscription<Position>? _positionSubscription;

  @override
  Future<void> run(ServiceInstance service, Map<String, dynamic> params) async {
    final visitTaskId = params['taskId'] as int?;
    final intervalSeconds = params['intervalSeconds'] as int?;
    if (visitTaskId == null || intervalSeconds == null) {
      await service.stopSelf();
      return;
    }

    final session = await _readSession();
    if (session == null) {
      await service.stopSelf();
      return;
    }

    // WHY: `configure()` sets a generic "Starting background task…" title
    // that never changes on its own — without this, the sticky notification
    // stays on that placeholder for as long as the service runs.
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: 'Facility App',
        content: 'Tracking your location for an active visit',
      );
    }

    service.on('stop').listen((_) async {
      await _positionSubscription?.cancel();
      await service.stopSelf();
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        intervalDuration: Duration(seconds: intervalSeconds),
      ),
    ).listen(
      (position) => _ping(
        client: session.client,
        partnerId: session.partnerId,
        taskId: visitTaskId,
        position: position,
      ),
    );
  }

  Future<void> _ping({
    required RestClient client,
    required int partnerId,
    required int taskId,
    required Position position,
  }) async {
    if (position.isMocked) return;

    int? battery;
    try {
      battery = await Battery().batteryLevel;
    } catch (_) {
      battery = null;
    }

    final request = LocationPingSyncRequestEntity(
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

    try {
      await client.syncLocationPings(
        partnerId: partnerId,
        request: request.toJson(),
      );
    } on Object catch (e) {
      // WHY quiet: no caller is waiting on this ping; the next one, ~ the
      // configured interval away, tries again.
      Log.error('background location ping failed: $e');
    }
  }

  Future<({RestClient client, int partnerId})?> _readSession() async {
    const storage = FlutterSecureStorage();
    final raw = await storage.read(key: SecureStorageKey.sessionPayload.name);
    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;
    final entity = LoginResponseModel.fromJson(json).toEntity();
    final partnerId = entity.user.partnerId;
    if (partnerId == null) return null;

    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.base,
        headers: {
          'Authorization': 'Bearer ${entity.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          AppConfig.clientTypeHeader: AppConfig.clientType,
        },
      ),
    );

    return (
      client: RestClient(dio, baseUrl: Endpoints.base),
      partnerId: partnerId,
    );
  }
}
