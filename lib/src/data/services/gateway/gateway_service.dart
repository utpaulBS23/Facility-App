import 'package:dio/dio.dart';

import '../../../core/logger/log.dart';

/// Talks directly to a facility's local relay-controller gateway (a LAN
/// device, not the app backend) over its own HTTP API.
class GatewayService {
  GatewayService({required this.baseUrl, Dio? dio})
    : _dio = dio ?? _createDio(baseUrl);

  final String baseUrl;
  final Dio _dio;

  static const int _timeoutSeconds = 2;

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: _timeoutSeconds),
        receiveTimeout: const Duration(seconds: _timeoutSeconds),
        sendTimeout: const Duration(seconds: _timeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(_RetryInterceptor(dio));
    return dio;
  }

  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/health',
        options: Options(sendTimeout: const Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (e) {
      Log.error('Gateway health check failed: $e');
      return false;
    }
  }

  /// Raw relay map, e.g. `{"relays": {"1": true, "2": false}}`.
  Future<Map<String, dynamic>> getRelayStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/relay/status');

      if (response.statusCode != 200) {
        throw GatewayException(
          'Failed to get relay status: ${response.statusCode}',
        );
      }

      return response.data ?? {};
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<bool> controlRelay({
    required int relayNumber,
    required bool unlock,
    int duration = 3600,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/relay/control',
        data: {
          'relay': relayNumber,
          'state': unlock ? 1 : 0,
          'duration': duration,
        },
      );

      if (response.statusCode != 200) {
        throw GatewayException(
          'Failed to control relay: ${response.statusCode}',
        );
      }

      Log.info('Relay $relayNumber controlled: ${unlock ? 'UNLOCK' : 'LOCK'}');
      return true;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  GatewayException _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => GatewayException(
        'Connection timeout',
      ),
      DioExceptionType.receiveTimeout => GatewayException('Request timeout'),
      DioExceptionType.sendTimeout => GatewayException('Send timeout'),
      DioExceptionType.connectionError => GatewayException(
        'Gateway unreachable',
      ),
      _ => GatewayException(e.message ?? 'Unknown gateway error'),
    };
  }
}

class GatewayException implements Exception {
  GatewayException(this.message);

  final String message;

  @override
  String toString() => 'GatewayException: $message';
}

/// Retries idempotent gateway calls on transient network failures — the
/// gateway is a LAN device on flaky Wi-Fi, unlike the main API.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;

  static const int maxRetries = 3;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future.delayed(Duration(milliseconds: 100 * (retryCount + 1)));
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await _dio.request(
        err.requestOptions.path,
        cancelToken: err.requestOptions.cancelToken,
        onReceiveProgress: err.requestOptions.onReceiveProgress,
        onSendProgress: err.requestOptions.onSendProgress,
        queryParameters: err.requestOptions.queryParameters,
        data: err.requestOptions.data,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        ),
      );
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504;
  }
}
