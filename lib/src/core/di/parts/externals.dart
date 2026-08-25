part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();

  dio.interceptors.addAll([
    TokenManager(
      baseUrl: Endpoints.base,
      refreshTokenEndpoint: Endpoints.refreshToken,
      sessionService: ref.read(sessionServiceProvider),
      dio: Dio(
        BaseOptions(
          baseUrl: Endpoints.base,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      ),
    ),
    if (kDebugMode) PrettyDioLogger(requestHeader: true, requestBody: true),
  ]);

  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  return FlutterLocalNotificationsPlugin();
}
