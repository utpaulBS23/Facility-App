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
WatchUserSessionUseCase watchUserSessionUseCase(Ref ref) {
  return WatchUserSessionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
HasPermissionUseCase hasPermissionUseCase(Ref ref) {
  return HasPermissionUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
CheckInUseCase checkInUseCase(Ref ref) {
  return CheckInUseCase(
    ref.read(checkInRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
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
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApproveAttendanceUseCase approveAttendanceUseCase(Ref ref) {
  return ApproveAttendanceUseCase(
    ref.read(attendanceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RejectAttendanceUseCase rejectAttendanceUseCase(Ref ref) {
  return RejectAttendanceUseCase(
    ref.read(attendanceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
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
GetShiftGlobalConfigUseCase getShiftGlobalConfigUseCase(Ref ref) {
  return GetShiftGlobalConfigUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CheckOutUseCase checkOutUseCase(Ref ref) {
  return CheckOutUseCase(
    ref.read(checkOutRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
AssignShiftSlotUseCase assignShiftSlotUseCase(Ref ref) {
  return AssignShiftSlotUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
UnassignShiftSlotUseCase unassignShiftSlotUseCase(Ref ref) {
  return UnassignShiftSlotUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
MakeSlotLeadUseCase makeSlotLeadUseCase(Ref ref) {
  return MakeSlotLeadUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
SubmitManualAttendanceUseCase submitManualAttendanceUseCase(Ref ref) {
  return SubmitManualAttendanceUseCase(
    ref.read(manualAttendanceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CreateRosterUseCase createRosterUseCase(Ref ref) {
  return CreateRosterUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetRostersUseCase getRostersUseCase(Ref ref) {
  return GetRostersUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
PublishRosterUseCase publishRosterUseCase(Ref ref) {
  return PublishRosterUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetRosterShiftsUseCase getRosterShiftsUseCase(Ref ref) {
  return GetRosterShiftsUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetShiftTemplatesUseCase getShiftTemplatesUseCase(Ref ref) {
  return GetShiftTemplatesUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CreateShiftUseCase createShiftUseCase(Ref ref) {
  return CreateShiftUseCase(
    ref.read(shiftRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetFacilitiesUseCase getFacilitiesUseCase(Ref ref) {
  return GetFacilitiesUseCase(
    ref.read(facilityRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RefreshAttendanceUseCase refreshAttendanceUseCase(Ref ref) {
  return RefreshAttendanceUseCase(
    ref.read(manualAttendanceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
WithdrawAttendanceUseCase withdrawAttendanceUseCase(Ref ref) {
  return WithdrawAttendanceUseCase(
    ref.read(manualAttendanceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  return GetTasksUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetTaskDetailUseCase getTaskDetailUseCase(Ref ref) {
  return GetTaskDetailUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
StartIssueUseCase startIssueUseCase(Ref ref) {
  return StartIssueUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
UploadTaskMediaUseCase uploadTaskMediaUseCase(Ref ref) {
  return UploadTaskMediaUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CompleteIssueUseCase completeIssueUseCase(Ref ref) {
  return CompleteIssueUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetMyVisitsUseCase getMyVisitsUseCase(Ref ref) {
  return GetMyVisitsUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetVisitDetailUseCase getVisitDetailUseCase(Ref ref) {
  return GetVisitDetailUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CheckInVisitUseCase checkInVisitUseCase(Ref ref) {
  return CheckInVisitUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CaptureCheckInUseCase captureCheckInUseCase(Ref ref) {
  return CaptureCheckInUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetChecklistUseCase getChecklistUseCase(Ref ref) {
  return GetChecklistUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
SubmitChecklistUseCase submitChecklistUseCase(Ref ref) {
  return SubmitChecklistUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
SaveChecklistItemResponseUseCase saveChecklistItemResponseUseCase(Ref ref) {
  return SaveChecklistItemResponseUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

/// Leave Management UseCases
@riverpod
GetLeavePoliciesUseCase getLeavePoliciesUseCase(Ref ref) {
  return GetLeavePoliciesUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveBalancesUseCase getLeaveBalancesUseCase(Ref ref) {
  return GetLeaveBalancesUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RequestLeaveUseCase requestLeaveUseCase(Ref ref) {
  return RequestLeaveUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetMyLeavesUseCase getMyLeavesUseCase(Ref ref) {
  return GetMyLeavesUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveRequestDetailsUseCase getLeaveRequestDetailsUseCase(Ref ref) {
  return GetLeaveRequestDetailsUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CancelLeaveUseCase cancelLeaveUseCase(Ref ref) {
  return CancelLeaveUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveAttendantsUseCase getLeaveAttendantsUseCase(Ref ref) {
  return GetLeaveAttendantsUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveApprovalsUseCase getLeaveApprovalsUseCase(Ref ref) {
  return GetLeaveApprovalsUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApproveLeaveUseCase approveLeaveUseCase(Ref ref) {
  return ApproveLeaveUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RejectLeaveUseCase rejectLeaveUseCase(Ref ref) {
  return RejectLeaveUseCase(
    repository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetSupplyRequestsUseCase getSupplyRequestsUseCase(Ref ref) {
  return GetSupplyRequestsUseCase(
    ref.read(supplyRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetSupplyRequestDetailsUseCase getSupplyRequestDetailsUseCase(Ref ref) {
  return GetSupplyRequestDetailsUseCase(
    ref.read(supplyRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ApproveSupplyRequestUseCase approveSupplyRequestUseCase(Ref ref) {
  return ApproveSupplyRequestUseCase(
    ref.read(supplyRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RejectSupplyRequestUseCase rejectSupplyRequestUseCase(Ref ref) {
  return RejectSupplyRequestUseCase(
    ref.read(supplyRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetDeliveryForSupplyRequestUseCase getDeliveryForSupplyRequestUseCase(Ref ref) {
  return GetDeliveryForSupplyRequestUseCase(
    ref.read(deliveryRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ConfirmDeliveryUseCase confirmDeliveryUseCase(Ref ref) {
  return ConfirmDeliveryUseCase(
    ref.read(deliveryRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CreateSupplyRequestUseCase createSupplyRequestUseCase(Ref ref) {
  return CreateSupplyRequestUseCase(
    ref.read(supplyRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetItemCatalogUseCase getItemCatalogUseCase(Ref ref) {
  return GetItemCatalogUseCase(
    ref.read(itemCatalogRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}
