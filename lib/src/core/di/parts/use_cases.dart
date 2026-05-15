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
GetFacilityAttendantsUseCase getFacilityAttendantsUseCase(Ref ref) {
  return GetFacilityAttendantsUseCase(
    ref.read(attendantRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetShiftsUseCase getShiftsUseCase(Ref ref) {
  return GetShiftsUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CheckOutUseCase checkOutUseCase(Ref ref) {
  return CheckOutUseCase(ref.read(checkOutRepositoryProvider));
}

@riverpod
AssignStaffUseCase assignStaffUseCase(Ref ref) {
  return AssignStaffUseCase(
    ref.read(assignmentRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
SubmitManualAttendanceUseCase submitManualAttendanceUseCase(Ref ref) {
  return SubmitManualAttendanceUseCase(
    ref.read(manualAttendanceRepositoryProvider),
  );
}

@riverpod
RefreshAttendanceUseCase refreshAttendanceUseCase(Ref ref) {
  return RefreshAttendanceUseCase(ref.read(manualAttendanceRepositoryProvider));
}

@riverpod
WithdrawAttendanceUseCase withdrawAttendanceUseCase(Ref ref) {
  return WithdrawAttendanceUseCase(
    ref.read(manualAttendanceRepositoryProvider),
  );
}
