part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) =>
    const FlutterSecureStorage();

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

// WHY: a bare Dio, no auth/json interceptors or headers — APK downloads hit
// a plain S3 URL, and the API dio's Authorization/Content-Type headers make
// S3 reject the request with 400 Bad Request.
@Riverpod(keepAlive: true)
Dio downloadDio(Ref ref) => Dio();

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  return FlutterLocalNotificationsPlugin();
}

@Riverpod(keepAlive: true)
FirebaseMessaging firebaseMessaging(Ref ref) {
  return FirebaseMessaging.instance;
}
