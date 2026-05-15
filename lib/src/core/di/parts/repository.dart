part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    session: ref.read(sessionServiceProvider),
  );
}

@Riverpod(keepAlive: true)
RouterRepository routerRepository(Ref ref) {
  return RouterRepositoryImpl(cacheService: ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
LocaleRepository localeRepository(Ref ref) {
  return LocaleRepositoryImpl(ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) {
  return LocationRepositoryImpl(ref.read(locationServiceProvider));
}

@Riverpod(keepAlive: true)
SelfieRepository selfieRepository(Ref ref) {
  return SelfieRepositoryImpl(
    ref.read(imagePickerServiceProvider),
    ref.read(faceDetectionServiceProvider),
  );
}

@Riverpod(keepAlive: true)
AttendanceRepository attendanceRepository(Ref ref) {
  return AttendanceRepositoryImpl();
}

@Riverpod(keepAlive: true)
FaceValidationRepository faceValidationRepository(Ref ref) {
  return FaceValidationRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
DeviceInfoRepository deviceInfoRepository(Ref ref) {
  return DeviceInfoRepositoryImpl(ref.read(deviceInfoServiceProvider));
}

@Riverpod(keepAlive: true)
ShiftRepository shiftRepository(Ref ref) {
  return ShiftRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
AttendantRepository attendantRepository(Ref ref) {
  return AttendantRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
CheckOutRepository checkOutRepository(Ref ref) {
  return CheckOutRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
AssignmentRepository assignmentRepository(Ref ref) {
  return AssignmentRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
ManualAttendanceRepository manualAttendanceRepository(Ref ref) {
  return ManualAttendanceRepositoryImpl(ref.read(restClientServiceProvider));
}
