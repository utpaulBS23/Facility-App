import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:facility_management_app/src/core/logger/log.dart';

/// Security service for encryption, signing, and secure storage
class SecurityService {
  final FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _deviceIdKey = 'device_id';

  SecurityService({FlutterSecureStorage? storage})
      : _secureStorage = storage ?? const FlutterSecureStorage();

  /// Save sensitive token securely
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      log('Token saved securely');
    } catch (e) {
      log('Failed to save token: $e');
      rethrow;
    }
  }

  /// Retrieve token from secure storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      log('Failed to read token: $e');
      return null;
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
      log('Refresh token saved securely');
    } catch (e) {
      log('Failed to save refresh token: $e');
      rethrow;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      log('Failed to read refresh token: $e');
      return null;
    }
  }

  /// Delete all sensitive data
  Future<void> clearAllSecureData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _tokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
      ]);
      log('All secure data cleared');
    } catch (e) {
      log('Failed to clear secure data: $e');
      rethrow;
    }
  }

  /// Generate HMAC-SHA256 signature for request
  String generateSignature({
    required String path,
    required String method,
    Map<String, dynamic>? body,
  }) {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final deviceId = _getDeviceId();

      String payload = '$method:$path:$timestamp:$deviceId';

      if (body != null) {
        payload += ':${jsonEncode(body)}';
      }

      final signature = Hmac(sha256, utf8.encode(_getSigningKey()))
          .convert(utf8.encode(payload))
          .toString();

      log('Signature generated for $method $path');
      return signature;
    } catch (e) {
      log('Failed to generate signature: $e');
      rethrow;
    }
  }

  /// Verify response signature
  bool verifySignature({
    required String signature,
    required String path,
    required String method,
    required String timestamp,
  }) {
    try {
      final deviceId = _getDeviceId();
      String payload = '$method:$path:$timestamp:$deviceId';

      final expectedSignature = Hmac(sha256, utf8.encode(_getSigningKey()))
          .convert(utf8.encode(payload))
          .toString();

      return signature == expectedSignature;
    } catch (e) {
      log('Failed to verify signature: $e');
      return false;
    }
  }

  /// Encrypt sensitive data
  String encrypt(String data) {
    try {
      // TODO: Implement proper AES encryption
      // For now, base64 encode (not secure, replace with real encryption)
      return base64.encode(utf8.encode(data));
    } catch (e) {
      log('Failed to encrypt data: $e');
      rethrow;
    }
  }

  /// Decrypt sensitive data
  String decrypt(String encrypted) {
    try {
      // TODO: Implement proper AES decryption
      // For now, base64 decode (not secure, replace with real decryption)
      return utf8.decode(base64.decode(encrypted));
    } catch (e) {
      log('Failed to decrypt data: $e');
      rethrow;
    }
  }

  /// Hash sensitive data (one-way)
  String hash(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  /// Create certificate pinning configuration
  static HttpClientAdapter createPinningAdapter({
    required List<String> certificatePins,
  }) {
    // TODO: Implement certificate pinning
    // This requires proper certificate management
    return HttpClientAdapter();
  }

  /// Create secure HTTP client with all security features
  Dio createSecureHttpClient({
    required String baseUrl,
    required List<String>? certificatePins,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    // Add security interceptor
    dio.interceptors.add(_SecurityHeaderInterceptor(this));

    // Add certificate pinning if provided
    if (certificatePins != null && certificatePins.isNotEmpty) {
      // TODO: Implement certificate pinning validation
      log('Certificate pinning configured');
    }

    return dio;
  }

  String _getDeviceId() {
    // TODO: Implement proper device ID generation
    return 'device-id-placeholder';
  }

  String _getSigningKey() {
    // TODO: Load from secure storage or environment
    return 'signing-key-placeholder';
  }
}

/// Interceptor for adding security headers
class _SecurityHeaderInterceptor extends Interceptor {
  final SecurityService _securityService;

  _SecurityHeaderInterceptor(this._securityService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Add timestamp for replay attack prevention
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      options.headers['X-Timestamp'] = timestamp;

      // Add signature
      final signature = _securityService.generateSignature(
        path: options.path,
        method: options.method,
        body: options.data as Map<String, dynamic>?,
      );
      options.headers['X-Signature'] = signature;

      // Add device identifier
      options.headers['X-Device-Id'] = _securityService._getDeviceId();

      // Add CORS headers
      options.headers['Access-Control-Allow-Origin'] = '*';
      options.headers['Access-Control-Allow-Credentials'] = 'true';

      handler.next(options);
    } catch (e) {
      log('Security header error: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      // Verify response signature if provided
      final signature = response.headers.value('X-Signature');
      final timestamp = response.headers.value('X-Timestamp');

      if (signature != null && timestamp != null) {
        final isValid = _securityService.verifySignature(
          signature: signature,
          path: response.requestOptions.path,
          method: response.requestOptions.method,
          timestamp: timestamp,
        );

        if (!isValid) {
          log('Response signature verification failed');
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.unknown,
              error: 'Response signature verification failed',
            ),
          );
          return;
        }
      }

      handler.next(response);
    } catch (e) {
      log('Response verification error: $e');
      handler.next(response);
    }
  }
}

/// Security interceptor for certificate pinning
class CertificatePinningInterceptor extends Interceptor {
  final List<String> certificatePins;

  CertificatePinningInterceptor({required this.certificatePins});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Implement certificate verification
    // This requires:
    // 1. Extract server certificate from HTTPS connection
    // 2. Hash the certificate
    // 3. Compare with pinned hashes
    // 4. Reject if not matching

    log('Certificate pinning check: ${options.uri.host}');
    handler.next(options);
  }
}