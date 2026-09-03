part of '../dependency_injection.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  return RestoreSessionUseCase(ref.read(authenticationRepositoryProvider));
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
WatchUserSessionUseCase watchUserSessionUseCase(Ref ref) {
  return WatchUserSessionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
CheckVersionUseCase checkVersionUseCase(Ref ref) {
  return CheckVersionUseCase(ref.read(appUpdateRepositoryProvider));
}

@riverpod
ReportUpdateActionUseCase reportUpdateActionUseCase(Ref ref) {
  return ReportUpdateActionUseCase(ref.read(appUpdateRepositoryProvider));
}

@riverpod
CheckInUseCase checkInUseCase(Ref ref) {
  return CheckInUseCase(ref.read(checkInRepositoryProvider));
}

@riverpod
CheckOutUseCase checkOutUseCase(Ref ref) {
  return CheckOutUseCase(ref.read(checkOutRepositoryProvider));
}

@riverpod
UploadSelfieUseCase uploadSelfieUseCase(Ref ref) {
  return UploadSelfieUseCase(ref.read(selfieRepositoryProvider));
}

@riverpod
VerifySelfieUseCase verifySelfieUseCase(Ref ref) {
  return VerifySelfieUseCase(ref.read(selfieRepositoryProvider));
}

@riverpod
GetAttendanceHistoryUseCase getAttendanceHistoryUseCase(Ref ref) {
  return GetAttendanceHistoryUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
GetTodayAttendanceUseCase getTodayAttendanceUseCase(Ref ref) {
  return GetTodayAttendanceUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
GetMyAttendanceUseCase getMyAttendanceUseCase(Ref ref) {
  return GetMyAttendanceUseCase(ref.read(myAttendanceRepositoryProvider));
}

@riverpod
GetManualAttendanceHistoryUseCase getManualAttendanceHistoryUseCase(Ref ref) {
  return GetManualAttendanceHistoryUseCase(
      ref.read(manualAttendanceRepositoryProvider));
}

@riverpod
RequestManualAttendanceUseCase requestManualAttendanceUseCase(Ref ref) {
  return RequestManualAttendanceUseCase(
      ref.read(manualAttendanceRepositoryProvider));
}

@riverpod
ApproveManualAttendanceUseCase approveManualAttendanceUseCase(Ref ref) {
  return ApproveManualAttendanceUseCase(
      ref.read(manualAttendanceRepositoryProvider));
}

@riverpod
RejectManualAttendanceUseCase rejectManualAttendanceUseCase(Ref ref) {
  return RejectManualAttendanceUseCase(
      ref.read(manualAttendanceRepositoryProvider));
}

@riverpod
GetShiftsUseCase getShiftsUseCase(Ref ref) {
  return GetShiftsUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
GetTodayShiftUseCase getTodayShiftUseCase(Ref ref) {
  return GetTodayShiftUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
GetStaffShiftsUseCase getStaffShiftsUseCase(Ref ref) {
  return GetStaffShiftsUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
AssignShiftUseCase assignShiftUseCase(Ref ref) {
  return AssignShiftUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
SwapShiftUseCase swapShiftUseCase(Ref ref) {
  return SwapShiftUseCase(ref.read(shiftRepositoryProvider));
}

@riverpod
GetMyLeavesUseCase getMyLeavesUseCase(Ref ref) {
  return GetMyLeavesUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApplyLeaveUseCase applyLeaveUseCase(Ref ref) {
  return ApplyLeaveUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CancelLeaveUseCase cancelLeaveUseCase(Ref ref) {
  return CancelLeaveUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApproveLeaveUseCase approveLeaveUseCase(Ref ref) {
  return ApproveLeaveUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RejectLeaveUseCase rejectLeaveUseCase(Ref ref) {
  return RejectLeaveUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveApprovalsUseCase getLeaveApprovalsUseCase(Ref ref) {
  return GetLeaveApprovalsUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveBalancesUseCase getLeaveBalancesUseCase(Ref ref) {
  return GetLeaveBalancesUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveAttendantsUseCase getLeaveAttendantsUseCase(Ref ref) {
  return GetLeaveAttendantsUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  return GetTasksUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
GetTaskDetailsUseCase getTaskDetailsUseCase(Ref ref) {
  return GetTaskDetailsUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  return CreateTaskUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
UpdateTaskStatusUseCase updateTaskStatusUseCase(Ref ref) {
  return UpdateTaskStatusUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
CompleteTaskUseCase completeTaskUseCase(Ref ref) {
  return CompleteTaskUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
AssignTaskUseCase assignTaskUseCase(Ref ref) {
  return AssignTaskUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
GetTaskOccurrencesUseCase getTaskOccurrencesUseCase(Ref ref) {
  return GetTaskOccurrencesUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
GetTaskOccurrenceDetailsUseCase getTaskOccurrenceDetailsUseCase(Ref ref) {
  return GetTaskOccurrenceDetailsUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
StartTaskOccurrenceUseCase startTaskOccurrenceUseCase(Ref ref) {
  return StartTaskOccurrenceUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
CompleteTaskOccurrenceUseCase completeTaskOccurrenceUseCase(Ref ref) {
  return CompleteTaskOccurrenceUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
VerifyTaskOccurrenceUseCase verifyTaskOccurrenceUseCase(Ref ref) {
  return VerifyTaskOccurrenceUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
RejectTaskOccurrenceUseCase rejectTaskOccurrenceUseCase(Ref ref) {
  return RejectTaskOccurrenceUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
SubmitChecklistItemUseCase submitChecklistItemUseCase(Ref ref) {
  return SubmitChecklistItemUseCase(
      ref.read(taskOccurrenceRepositoryProvider));
}

@riverpod
GetVisitsUseCase getVisitsUseCase(Ref ref) {
  return GetVisitsUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetVisitDetailsUseCase getVisitDetailsUseCase(Ref ref) {
  return GetVisitDetailsUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
CreateVisitUseCase createVisitUseCase(Ref ref) {
  return CreateVisitUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
StartVisitUseCase startVisitUseCase(Ref ref) {
  return StartVisitUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
CompleteVisitUseCase completeVisitUseCase(Ref ref) {
  return CompleteVisitUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetTravelRoutesUseCase getTravelRoutesUseCase(Ref ref) {
  return GetTravelRoutesUseCase(ref.read(travelRouteRepositoryProvider));
}

@riverpod
GetTravelRouteDetailsUseCase getTravelRouteDetailsUseCase(Ref ref) {
  return GetTravelRouteDetailsUseCase(ref.read(travelRouteRepositoryProvider));
}

@riverpod
StartTravelRouteUseCase startTravelRouteUseCase(Ref ref) {
  return StartTravelRouteUseCase(ref.read(travelRouteRepositoryProvider));
}

@riverpod
CompleteTravelRouteUseCase completeTravelRouteUseCase(Ref ref) {
  return CompleteTravelRouteUseCase(ref.read(travelRouteRepositoryProvider));
}

@riverpod
GetStaffListUseCase getStaffListUseCase(Ref ref) {
  return GetStaffListUseCase(ref.read(partnerStaffRepositoryProvider));
}

@riverpod
GetStaffDetailsUseCase getStaffDetailsUseCase(Ref ref) {
  return GetStaffDetailsUseCase(ref.read(partnerStaffRepositoryProvider));
}

@riverpod
GetTravelExpensesUseCase getTravelExpensesUseCase(Ref ref) {
  return GetTravelExpensesUseCase(ref.read(travelExpenseRepositoryProvider));
}

@riverpod
CreateTravelExpenseUseCase createTravelExpenseUseCase(Ref ref) {
  return CreateTravelExpenseUseCase(ref.read(travelExpenseRepositoryProvider));
}

@riverpod
ApproveTravelExpenseUseCase approveTravelExpenseUseCase(Ref ref) {
  return ApproveTravelExpenseUseCase(
      ref.read(travelExpenseRepositoryProvider));
}

@riverpod
RejectTravelExpenseUseCase rejectTravelExpenseUseCase(Ref ref) {
  return RejectTravelExpenseUseCase(
      ref.read(travelExpenseRepositoryProvider));
}

@riverpod
GetMasterDataUseCase getMasterDataUseCase(Ref ref) {
  return GetMasterDataUseCase(ref.read(masterDataRepositoryProvider));
}

@riverpod
GetLocationPingConfigUseCase getLocationPingConfigUseCase(Ref ref) {
  return GetLocationPingConfigUseCase(
      ref.read(locationPingRepositoryProvider));
}

@riverpod
SendLocationPingUseCase sendLocationPingUseCase(Ref ref) {
  return SendLocationPingUseCase(ref.read(locationPingRepositoryProvider));
}

@riverpod
GetCurrentLocationUseCase getCurrentLocationUseCase(Ref ref) {
  return GetCurrentLocationUseCase(ref.read(locationRepositoryProvider));
}

@riverpod
WatchLocationUpdatesUseCase watchLocationUpdatesUseCase(Ref ref) {
  return WatchLocationUpdatesUseCase(ref.read(locationRepositoryProvider));
}

@riverpod
GetDeviceIdUseCase getDeviceIdUseCase(Ref ref) {
  return GetDeviceIdUseCase(ref.read(deviceInfoRepositoryProvider));
}

@riverpod
GetDeviceInfoUseCase getDeviceInfoUseCase(Ref ref) {
  return GetDeviceInfoUseCase(ref.read(deviceInfoRepositoryProvider));
}

@riverpod
GetLocaleUseCase getLocaleUseCase(Ref ref) {
  return GetLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
SetLocaleUseCase setLocaleUseCase(Ref ref) {
  return SetLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
GetSavedRouteUseCase getSavedRouteUseCase(Ref ref) {
  return GetSavedRouteUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
SaveRouteUseCase saveRouteUseCase(Ref ref) {
  return SaveRouteUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
GetSupplyRequestsUseCase getSupplyRequestsUseCase(Ref ref) {
  return GetSupplyRequestsUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetSupplyRequestSummaryUseCase getSupplyRequestSummaryUseCase(Ref ref) {
  return GetSupplyRequestSummaryUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetSupplyRequestDetailsUseCase getSupplyRequestDetailsUseCase(Ref ref) {
  return GetSupplyRequestDetailsUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApproveSupplyRequestUseCase approveSupplyRequestUseCase(Ref ref) {
  return ApproveSupplyRequestUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RejectSupplyRequestUseCase rejectSupplyRequestUseCase(Ref ref) {
  return RejectSupplyRequestUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
DispatchSupplyRequestUseCase dispatchSupplyRequestUseCase(Ref ref) {
  return DispatchSupplyRequestUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetDeliveryForSupplyRequestUseCase getDeliveryForSupplyRequestUseCase(
    Ref ref) {
  return GetDeliveryForSupplyRequestUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ConfirmDeliveryUseCase confirmDeliveryUseCase(Ref ref) {
  return ConfirmDeliveryUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
FileDeliveryComplaintUseCase fileDeliveryComplaintUseCase(Ref ref) {
  return FileDeliveryComplaintUseCase(
    supplyRepository: ref.read(supplyRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetPushTokenUseCase getPushTokenUseCase(Ref ref) {
  return GetPushTokenUseCase(ref.read(pushNotificationRepositoryProvider));
}

@riverpod
RegisterPushTokenUseCase registerPushTokenUseCase(Ref ref) {
  return RegisterPushTokenUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
UnregisterPushTokenUseCase unregisterPushTokenUseCase(Ref ref) {
  return UnregisterPushTokenUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetProfileUseCase getProfileUseCase(Ref ref) {
  return GetProfileUseCase(repository: ref.read(profileRepositoryProvider));
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) {
  return UpdateProfileUseCase(repository: ref.read(profileRepositoryProvider));
}

@riverpod
SendForgotPasswordOtpUseCase sendForgotPasswordOtpUseCase(Ref ref) {
  return SendForgotPasswordOtpUseCase(repository: ref.read(forgotPasswordRepositoryProvider));
}

@riverpod
VerifyForgotPasswordOtpUseCase verifyForgotPasswordOtpUseCase(Ref ref) {
  return VerifyForgotPasswordOtpUseCase(repository: ref.read(forgotPasswordRepositoryProvider));
}

@riverpod
ResetForgotPasswordUseCase resetForgotPasswordUseCase(Ref ref) {
  return ResetForgotPasswordUseCase(repository: ref.read(forgotPasswordRepositoryProvider));
}
