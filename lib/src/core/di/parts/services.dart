part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
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
LocationService locationService(Ref ref) {
  return LocationServiceImpl();
}
