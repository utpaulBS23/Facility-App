part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  return FlutterSecureStorageService(ref.read(flutterSecureStorageProvider));
}

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  final service = InMemorySessionService();
  ref.onDispose(service.dispose);

  return service;
}

@Riverpod(keepAlive: true)
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider));
}

@Riverpod(keepAlive: true)
FaceDetectionService faceDetectionService(Ref ref) {
  // ignore: invalid_service_name
  final service = FaceDetectionServiceImpl();
  ref.onDispose(service.close);

  return service;
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationServiceImpl();
}

@Riverpod(keepAlive: true)
BackgroundLocationTrackingService backgroundLocationTrackingService(Ref ref) {
  final service = BackgroundLocationTrackingServiceImpl();
  ref.onDispose(service.stop);

  return service;
}

@Riverpod(keepAlive: true)
LocationSharingNotificationService locationSharingNotificationService(Ref ref) {
  return LocationSharingNotificationServiceImpl(
    ref.read(flutterLocalNotificationsPluginProvider),
  );
}

@Riverpod(keepAlive: true)
DeviceInfoService deviceInfoService(Ref ref) {
  return DeviceInfoServiceImpl(DeviceInfoPlugin());
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationServiceImpl(
    messaging: ref.read(firebaseMessagingProvider),
    notifications: ref.read(flutterLocalNotificationsPluginProvider),
  );
}
