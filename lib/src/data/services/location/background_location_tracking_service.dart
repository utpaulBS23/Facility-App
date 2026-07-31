import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

abstract class BackgroundLocationTrackingService {
  bool get isRunning;

  void start({
    required Duration interval,
    required Future<void> Function(Position position) onPosition,
    bool fireImmediately = false,
  });

  void stop();
}

final class BackgroundLocationTrackingServiceImpl
    implements BackgroundLocationTrackingService {
  StreamSubscription<Position>? _subscription;
  Timer? _timer;
  Position? _latestPosition;
  bool _isHandlingPosition = false;

  @override
  bool get isRunning => _subscription != null;

  @override
  void start({
    required Duration interval,
    required Future<void> Function(Position position) onPosition,
    bool fireImmediately = false,
  }) {
    stop();

    final settings = _locationSettings(interval);
    if (fireImmediately) {
      unawaited(
        _emitCurrentPosition(settings: settings, onPosition: onPosition),
      );
    }

    _subscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((position) => unawaited(_handlePosition(position, onPosition)));

    _timer = Timer.periodic(interval, (_) {
      final position = _latestPosition;
      if (position == null) return;

      unawaited(_handlePosition(position, onPosition));
    });
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    unawaited(_subscription?.cancel());
    _subscription = null;
    _latestPosition = null;
    _isHandlingPosition = false;
  }

  LocationSettings _locationSettings(Duration interval) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        intervalDuration: interval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Location sharing active',
          notificationText: 'Your location is being shared every 10 seconds.',
          notificationChannelName: 'Location Sharing',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }

    return LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0);
  }

  Future<void> _emitCurrentPosition({
    required LocationSettings settings,
    required Future<void> Function(Position position) onPosition,
  }) async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: settings,
    );
    await _handlePosition(position, onPosition);
  }

  Future<void> _handlePosition(
    Position position,
    Future<void> Function(Position position) onPosition,
  ) async {
    _latestPosition = position;
    if (_isHandlingPosition) return;

    _isHandlingPosition = true;
    try {
      await onPosition(position);
    } finally {
      _isHandlingPosition = false;
    }
  }
}
