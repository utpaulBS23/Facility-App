part of '../dependency_injection.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetUserSessionUseCase getUserSessionUseCase(Ref ref) {
  return GetUserSessionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
ValidateFaceUseCase validateFaceUseCase(Ref ref) {
  return ValidateFaceUseCase(ref.read(faceValidationRepositoryProvider));
}

@riverpod
GetDeviceNameUseCase getDeviceNameUseCase(Ref ref) {
  return GetDeviceNameUseCase(ref.read(deviceInfoRepositoryProvider));
}

@riverpod
GetCurrentLocaleUseCase getCurrentLocaleUseCase(Ref ref) {
  return GetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
SetCurrentLocaleUseCase setCurrentLocaleUseCase(Ref ref) {
  return SetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
ResetRepositoryUseCase resetRepositoryUseCase(Ref ref) {
  return const ResetRepositoryUseCase();
}

@riverpod
GetOnboardingStatusUseCase getOnboardingStatusUseCase(Ref ref) {
  return GetOnboardingStatusUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
MarkOnboardingCompletedUseCase markOnboardingCompletedUseCase(Ref ref) {
  return MarkOnboardingCompletedUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
PickSelfieUseCase pickSelfieUseCase(Ref ref) {
  return PickSelfieUseCase(ref.read(selfieRepositoryProvider));
}

@riverpod
GetCurrentLocationUseCase getCurrentLocationUseCase(Ref ref) {
  return GetCurrentLocationUseCase(ref.read(locationRepositoryProvider));
}

@riverpod
GetAttendanceSummaryUseCase getAttendanceSummaryUseCase(Ref ref) {
  return GetAttendanceSummaryUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
GetAttendanceDetailUseCase getAttendanceDetailUseCase(Ref ref) {
  return GetAttendanceDetailUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
GetMyShiftsUseCase getMyShiftsUseCase(Ref ref) {
  return GetMyShiftsUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
GetSupervisorShiftsUseCase getSupervisorShiftsUseCase(Ref ref) {
  return GetSupervisorShiftsUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
CheckOutUseCase checkOutUseCase(Ref ref) {
  return CheckOutUseCase(ref.read(checkOutRepositoryProvider));
}
