part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  final repository = AuthenticationRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    session: ref.read(sessionServiceProvider),
  );
  ref.onDispose(repository.dispose);

  return repository;
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
LocationPingRepository locationPingRepository(Ref ref) {
  return LocationPingRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    trackingService: ref.read(backgroundLocationTrackingServiceProvider),
    notificationService: ref.read(locationSharingNotificationServiceProvider),
    authenticationRepository: ref.read(authenticationRepositoryProvider),
  );
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
  return AttendanceRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
CheckInRepository checkInRepository(Ref ref) {
  return CheckInRepositoryImpl(ref.read(restClientServiceProvider));
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
CheckOutRepository checkOutRepository(Ref ref) {
  return CheckOutRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
PartnerStaffRepository partnerStaffRepository(Ref ref) {
  return PartnerStaffRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
ManualAttendanceRepository manualAttendanceRepository(Ref ref) {
  return ManualAttendanceRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
VisitRepository visitRepository(Ref ref) {
  return VisitRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
TaskOccurrenceRepository taskOccurrenceRepository(Ref ref) {
  return TaskOccurrenceRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
LeaveRepository leaveRepository(Ref ref) {
  return LeaveRepositoryImpl(ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
AppUpdateRepository appUpdateRepository(Ref ref) {
  return AppUpdateRepositoryImpl(
    ref.read(restClientServiceProvider),
    ref.read(dioProvider),
  );
}

@Riverpod(keepAlive: true)
SupplyRepository supplyRepository(Ref ref) {
  return SupplyRepositoryImpl(remote: ref.read(restClientServiceProvider));
}

