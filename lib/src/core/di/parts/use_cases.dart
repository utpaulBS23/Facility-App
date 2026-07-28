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
GetActivePartnerUseCase getActivePartnerUseCase(Ref ref) {
  return GetActivePartnerUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
WatchUserSessionUseCase watchUserSessionUseCase(Ref ref) {
  return WatchUserSessionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
HasPermissionUseCase hasPermissionUseCase(Ref ref) {
  return HasPermissionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
CheckInUseCase checkInUseCase(Ref ref) {
  return CheckInUseCase(ref.read(checkInRepositoryProvider));
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
GetMonthlyAttendanceOverviewUseCase getMonthlyAttendanceOverviewUseCase(
  Ref ref,
) {
  return GetMonthlyAttendanceOverviewUseCase(
    ref.read(attendanceRepositoryProvider),
  );
}

@riverpod
ApproveAttendanceUseCase approveAttendanceUseCase(Ref ref) {
  return ApproveAttendanceUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
RejectAttendanceUseCase rejectAttendanceUseCase(Ref ref) {
  return RejectAttendanceUseCase(ref.read(attendanceRepositoryProvider));
}

@riverpod
GetPartnerStaffUseCase getPartnerStaffUseCase(Ref ref) {
  return GetPartnerStaffUseCase(
    ref.read(partnerStaffRepositoryProvider),
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
GetShiftSlotsUseCase getShiftSlotsUseCase(Ref ref) {
  return GetShiftSlotsUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CheckOutUseCase checkOutUseCase(Ref ref) {
  return CheckOutUseCase(ref.read(checkOutRepositoryProvider));
}

@riverpod
AssignShiftSlotUseCase assignShiftSlotUseCase(Ref ref) {
  return AssignShiftSlotUseCase(
    ref.read(shiftRepositoryProvider),
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

@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  return GetTasksUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
GetTaskDetailUseCase getTaskDetailUseCase(Ref ref) {
  return GetTaskDetailUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
StartIssueUseCase startIssueUseCase(Ref ref) {
  return StartIssueUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
UploadTaskMediaUseCase uploadTaskMediaUseCase(Ref ref) {
  return UploadTaskMediaUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
CompleteIssueUseCase completeIssueUseCase(Ref ref) {
  return CompleteIssueUseCase(ref.read(taskRepositoryProvider));
}

@riverpod
GetMyVisitsUseCase getMyVisitsUseCase(Ref ref) {
  return GetMyVisitsUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetVisitDetailUseCase getVisitDetailUseCase(Ref ref) {
  return GetVisitDetailUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
CheckInVisitUseCase checkInVisitUseCase(Ref ref) {
  return CheckInVisitUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
CaptureCheckInUseCase captureCheckInUseCase(Ref ref) {
  return CaptureCheckInUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetChecklistUseCase getChecklistUseCase(Ref ref) {
  return GetChecklistUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
SubmitChecklistUseCase submitChecklistUseCase(Ref ref) {
  return SubmitChecklistUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
SubmitVisitUseCase submitVisitUseCase(Ref ref) {
  return SubmitVisitUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
SaveChecklistItemResponseUseCase saveChecklistItemResponseUseCase(Ref ref) {
  return SaveChecklistItemResponseUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
ReportIssueUseCase reportIssueUseCase(Ref ref) {
  return ReportIssueUseCase(ref.read(visitRepositoryProvider));
}

/// Leave Management UseCases
@riverpod
GetLeavePoliciesUseCase getLeavePoliciesUseCase(Ref ref) {
  return GetLeavePoliciesUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetLeaveBalancesUseCase getLeaveBalancesUseCase(Ref ref) {
  return GetLeaveBalancesUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
RequestLeaveUseCase requestLeaveUseCase(Ref ref) {
  return RequestLeaveUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetMyLeavesUseCase getMyLeavesUseCase(Ref ref) {
  return GetMyLeavesUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetLeaveRequestDetailsUseCase getLeaveRequestDetailsUseCase(Ref ref) {
  return GetLeaveRequestDetailsUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
CancelLeaveUseCase cancelLeaveUseCase(Ref ref) {
  return CancelLeaveUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetLeaveAttendantsUseCase getLeaveAttendantsUseCase(Ref ref) {
  return GetLeaveAttendantsUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetLeaveApprovalsUseCase getLeaveApprovalsUseCase(Ref ref) {
  return GetLeaveApprovalsUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
ApproveLeaveUseCase approveLeaveUseCase(Ref ref) {
  return ApproveLeaveUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
RejectLeaveUseCase rejectLeaveUseCase(Ref ref) {
  return RejectLeaveUseCase(ref.read(leaveRepositoryProvider));
}

@riverpod
GetSupplyRequestsUseCase getSupplyRequestsUseCase(Ref ref) {
  return GetSupplyRequestsUseCase(ref.read(supplyRepositoryProvider));
}
