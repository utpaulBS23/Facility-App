import 'package:dio/dio.dart';

import '../../core/base/exceptions.dart';
import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../core/logger/log.dart';
import '../../domain/repositories/device_token_repository.dart';
import '../models/notification/device_token_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/rest_client.dart';

final class DeviceTokenRepositoryImpl extends DeviceTokenRepository {
  DeviceTokenRepositoryImpl({
    required this.remote,
    required this.local,
    required this.platform,
  });

  final RestClient remote;
  final CacheService local;

  /// `android` or `ios`, as the server names them.
  final String platform;

  /// How long a topic sync stays fresh. A facility assignment or role can
  /// change on the server without the app hearing of it.
  static const syncInterval = Duration(hours: 6);

  int? get _tokenId => local.get<int>(CacheKey.deviceTokenId);

  @override
  bool get isRegistered => _tokenId != null;

  @override
  Future<Result<void, Failure>> register(String fcmToken) {
    return asyncGuard(() async {
      final previousId = _tokenId;
      final response = await remote.registerDeviceToken(
        body: DeviceTokenRequestModel(fcmToken: fcmToken, platform: platform),
      );
      final id = DeviceTokenResponseModel.fromJson(response.data).id;
      await local.save(CacheKey.deviceTokenId, id);
      await local.save(CacheKey.fcmToken, fcmToken);

      // WHY a failed sync does not fail the registration: the token is
      // already usable for direct pushes, and the next resume syncs again.
      try {
        await _sync(id);
      } on DioException catch (e) {
        Log.warning('Topic sync failed after registering: ${e.message}');
      }

      if (previousId != null && previousId != id) {
        await _delete(previousId);
      }
    });
  }

  @override
  Future<Result<void, Failure>> syncTopics({bool force = false}) {
    return asyncGuard(() async {
      final id = _tokenId;
      if (id == null) return;
      if (!force && !_syncIsStale()) return;

      try {
        await _sync(id);
      } on DioException catch (e) {
        // WHY forget the id on a 404: the server no longer has this token, so
        // the next registration must start fresh.
        if (e.response?.statusCode == 404) {
          await _forget(id);
          // WHY named: a plain 404 reaches callers as a generic bad response,
          // and they need to tell "token gone" apart to register again. The
          // message is for logs; it is never shown to the user.
          throw const CustomException.notFound(
            message: 'Device token not found.',
          );
        }
        rethrow;
      }
    });
  }

  @override
  Future<Result<void, Failure>> unregister() {
    return asyncGuard(() async {
      final id = _tokenId;
      if (id == null) return;

      try {
        await _delete(id);
      } finally {
        await _forget(id);
      }
    });
  }

  /// Clears the stored registration, but only while it is still [id].
  ///
  /// WHY the check: a slow request can finish after the user signed in again
  /// and registered a new token. Clearing then would erase the new one.
  Future<void> _forget(int id) async {
    if (_tokenId != id) return;
    await local.remove([CacheKey.deviceTokenId, CacheKey.deviceTokenSyncedAt]);
  }

  bool _syncIsStale() {
    final syncedAt = local.get<int>(CacheKey.deviceTokenSyncedAt);
    if (syncedAt == null) return true;
    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(syncedAt),
    );

    return age >= syncInterval;
  }

  Future<void> _sync(int id) async {
    await remote.syncDeviceTokenTopics(id: id);
    await local.save(
      CacheKey.deviceTokenSyncedAt,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// A 404 means it is already gone, which is what was wanted.
  Future<void> _delete(int id) async {
    try {
      await remote.deleteDeviceToken(id: id);
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) rethrow;
    }
  }
}
