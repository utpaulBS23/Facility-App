part of 'secure_storage_service.dart';

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> save(SecureStorageKey key, String value) =>
      _storage.write(key: key.name, value: value);

  @override
  Future<String?> read(SecureStorageKey key) => _storage.read(key: key.name);

  @override
  Future<void> delete(SecureStorageKey key) => _storage.delete(key: key.name);
}
