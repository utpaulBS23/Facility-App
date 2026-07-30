part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  final service = InMemorySessionService();
  ref.onDispose(service.dispose);

  return service;
}

@riverpod
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider));
}

@riverpod
ImagePickerService imagePickerService(Ref ref) {
  return ImagePickerServiceImpl(ImagePicker());
}

@riverpod
FaceDetectionService faceDetectionService(Ref ref) {
  // ignore: invalid_service_name
  final service = FaceDetectionServiceImpl();
  ref.onDispose(service.close);

  return service;
}

@riverpod
LocationService locationService(Ref ref) {
  return LocationServiceImpl();
}

@riverpod
DeviceInfoService deviceInfoService(Ref ref) {
  return DeviceInfoServiceImpl(DeviceInfoPlugin());
}
