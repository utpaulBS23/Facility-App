import 'dart:async';

abstract class BackgroundLocationTrackingService {
  bool get isRunning;

  void start({
    required Duration interval,
    required Future<void> Function() onTick,
    bool fireImmediately = false,
  });

  void stop();
}

final class BackgroundLocationTrackingServiceImpl
    implements BackgroundLocationTrackingService {
  Timer? _timer;
  bool _isTicking = false;

  @override
  bool get isRunning => _timer?.isActive ?? false;

  @override
  void start({
    required Duration interval,
    required Future<void> Function() onTick,
    bool fireImmediately = false,
  }) {
    stop();

    if (fireImmediately) {
      unawaited(_runTick(onTick));
    }

    _timer = Timer.periodic(interval, (_) => unawaited(_runTick(onTick)));
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isTicking = false;
  }

  Future<void> _runTick(Future<void> Function() onTick) async {
    if (_isTicking) return;

    _isTicking = true;
    try {
      await onTick();
    } finally {
      _isTicking = false;
    }
  }
}
