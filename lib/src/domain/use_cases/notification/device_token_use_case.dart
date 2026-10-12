import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../repositories/device_token_repository.dart';
import '../../repositories/push_notification_repository.dart';

/// Registers this device for pushes after sign-in, or with [token] when
/// Firebase rotates it.
final class RegisterDeviceTokenUseCase {
  RegisterDeviceTokenUseCase(this._push, this._devices);

  final PushNotificationRepository _push;
  final DeviceTokenRepository _devices;

  Future<Result<void, Failure>> call({String? token}) async {
    final fcmToken = token ?? await _push.getDeviceToken();
    // WHY quiet: no token means push is unavailable here (no permission, no
    // Play services). The app works without it.
    if (fcmToken.isEmpty) return const Success();

    return _devices.register(fcmToken);
  }
}

/// Keeps the device's topics current. Registers first when the server has
/// lost track of the token.
final class SyncDeviceTopicsUseCase {
  SyncDeviceTopicsUseCase(this._push, this._devices);

  final PushNotificationRepository _push;
  final DeviceTokenRepository _devices;

  Future<Result<void, Failure>> call() async {
    if (_devices.isRegistered) {
      final result = await _devices.syncTopics();
      final gone =
          result is Error<void, Failure> &&
          result.error.type == FailureType.notFound;
      if (!gone) return result;
    }

    final fcmToken = await _push.getDeviceToken();
    if (fcmToken.isEmpty) return const Success();

    return _devices.register(fcmToken);
  }
}

final class UnregisterDeviceTokenUseCase {
  UnregisterDeviceTokenUseCase(this._devices);

  final DeviceTokenRepository _devices;

  Future<Result<void, Failure>> call() => _devices.unregister();
}
