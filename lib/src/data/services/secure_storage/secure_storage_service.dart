import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'flutter_secure_storage_service.dart';

/// Keys for values that must never sit in plain [CacheService]/
/// SharedPreferences storage — access tokens, cached session payloads.
enum SecureStorageKey { sessionPayload }

abstract class SecureStorageService {
  Future<void> save(SecureStorageKey key, String value);

  Future<String?> read(SecureStorageKey key);

  Future<void> delete(SecureStorageKey key);
}
