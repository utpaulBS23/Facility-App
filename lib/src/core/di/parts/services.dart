part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  return InMemorySessionService();
}

@Riverpod(keepAlive: true)
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider));
}

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(Ref ref) {
  return ImagePickerServiceImpl(ImagePicker());
}

@Riverpod(keepAlive: true)
FaceDetectionService faceDetectionService(Ref ref) {
  final service = FaceDetectionServiceImpl();
  ref.onDispose(service.close);
  return service;
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationServiceImpl();
}
