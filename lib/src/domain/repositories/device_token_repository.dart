import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';

/// Tells the server which device to push to, and which topics it joins.
abstract base class DeviceTokenRepository extends Repository {
  /// Whether the server knows this device's token under an id.
  bool get isRegistered;

  /// Registers [fcmToken] for the signed-in user, then syncs its topics. A
  /// token that replaces an earlier one removes the earlier one afterwards.
  /// A failed topic sync does not undo the registration.
  Future<Result<void, Failure>> register(String fcmToken);

  /// Brings the device's topics in line with the server. Skipped when the last
  /// sync was recent, unless [force]. Does nothing before [register].
  Future<Result<void, Failure>> syncTopics({bool force = false});

  /// Removes this device from the server. Safe to call when it was never
  /// registered or is already gone.
  Future<Result<void, Failure>> unregister();
}
