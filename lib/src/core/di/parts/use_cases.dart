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
GetOnboardingStatusUseCase getOnboardingStatusUseCase(Ref ref) {
  return GetOnboardingStatusUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
MarkOnboardingCompletedUseCase markOnboardingCompletedUseCase(Ref ref) {
  return MarkOnboardingCompletedUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
ValidateSelfieUseCase validateSelfieUseCase(Ref ref) {
  return ValidateSelfieUseCase(ref.read(selfieRepositoryProvider));
}

@riverpod
GetCurrentLocationUseCase getCurrentLocationUseCase(Ref ref) {
  return GetCurrentLocationUseCase(ref.read(locationRepositoryProvider));
}

@riverpod
StartLocationPingTrackingUseCase startLocationPingTrackingUseCase(Ref ref) {
  return StartLocationPingTrackingUseCase(
    ref.read(locationPingRepositoryProvider),
  );
}

@riverpod
StopLocationPingTrackingUseCase stopLocationPingTrackingUseCase(Ref ref) {
  return StopLocationPingTrackingUseCase(
    ref.read(locationPingRepositoryProvider),
  );
}

@riverpod
SyncCurrentLocationPingUseCase syncCurrentLocationPingUseCase(Ref ref) {
  return SyncCurrentLocationPingUseCase(
    ref.read(locationPingRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLocationSharingStatusUseCase getLocationSharingStatusUseCase(Ref ref) {
  return GetLocationSharingStatusUseCase(ref.read(locationPingRepositoryProvider));
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
GetMyAttendanceUseCase getMyAttendanceUseCase(Ref ref) {
  return GetMyAttendanceUseCase(
    ref.read(myAttendanceRepositoryProvider),
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
GetIssuesUseCase getIssuesUseCase(Ref ref) {
  return GetIssuesUseCase(
    ref.read(taskRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetIssueDetailUseCase getIssueDetailUseCase(Ref ref) {
  return GetIssueDetailUseCase(
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
TravelRouteCheckInUseCase travelRouteCheckInUseCase(Ref ref) {
  return TravelRouteCheckInUseCase(
    ref.read(travelRouteRepositoryProvider),
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
SubmitVisitUseCase submitVisitUseCase(Ref ref) {
  return SubmitVisitUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
WatchVisitSubmittedUseCase watchVisitSubmittedUseCase(Ref ref) {
  return WatchVisitSubmittedUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
SaveChecklistItemResponseUseCase saveChecklistItemResponseUseCase(Ref ref) {
  return SaveChecklistItemResponseUseCase(
    ref.read(visitRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

/// Task Occurrence UseCases

@riverpod
GetTaskOccurrencesUseCase getTaskOccurrencesUseCase(Ref ref) {
  return GetTaskOccurrencesUseCase(
    ref.read(taskOccurrenceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
ReassignTaskOccurrenceUseCase reassignTaskOccurrenceUseCase(Ref ref) {
  return ReassignTaskOccurrenceUseCase(
    ref.read(taskOccurrenceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
AnswerTaskOccurrenceChecklistItemUseCase
answerTaskOccurrenceChecklistItemUseCase(Ref ref) {
  return AnswerTaskOccurrenceChecklistItemUseCase(
    ref.read(taskOccurrenceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
SubmitTaskOccurrenceUseCase submitTaskOccurrenceUseCase(Ref ref) {
  return SubmitTaskOccurrenceUseCase(
    ref.read(taskOccurrenceRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

/// Leave Management UseCases

@riverpod
GetLeaveBalancesUseCase getLeaveBalancesUseCase(Ref ref) {
  return GetLeaveBalancesUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
RequestLeaveUseCase requestLeaveUseCase(Ref ref) {
  return RequestLeaveUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
CreateTravelExpenseUseCase createTravelExpenseUseCase(Ref ref) {
  return CreateTravelExpenseUseCase(
    ref.read(travelExpenseRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetMasterDataItemsUseCase getMasterDataItemsUseCase(Ref ref) {
  return GetMasterDataItemsUseCase(
    ref.read(masterDataRepositoryProvider),
    ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetMyLeavesUseCase getMyLeavesUseCase(Ref ref) {
  return GetMyLeavesUseCase(
    leaveRepository: ref.read(leaveRepositoryProvider),
    authRepository: ref.read(authenticationRepositoryProvider),
  );
}

@riverpod
GetLeaveRequestDetailsUseCase getLeaveRequestDetailsUseCase(Ref ref) {
  return GetLeaveRequestDetailsUseCase(
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
GetLeaveAttendantsUseCase getLeaveAttendantsUseCase(Ref ref) {
  return GetLeaveAttendantsUseCase(
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
ReportIssueUseCase reportIssueUseCase(Ref ref) {
  return ReportIssueUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetProblemCategoriesUseCase getProblemCategoriesUseCase(Ref ref) {
  return GetProblemCategoriesUseCase(ref.read(visitRepositoryProvider));
}

@riverpod
GetDeviceInfoUseCase getDeviceInfoUseCase(Ref ref) {
  return GetDeviceInfoUseCase(ref.read(deviceInfoRepositoryProvider));
}

@riverpod
CheckAppVersionUseCase checkAppVersionUseCase(Ref ref) {
  return CheckAppVersionUseCase(ref.read(appUpdateRepositoryProvider));
}

@riverpod
ReportAppUpdateActionUseCase reportAppUpdateActionUseCase(Ref ref) {
  return ReportAppUpdateActionUseCase(ref.read(appUpdateRepositoryProvider));
}

@riverpod
DownloadApkUseCase downloadApkUseCase(Ref ref) {
  return DownloadApkUseCase(ref.read(appUpdateRepositoryProvider));
}

@riverpod
InstallApkUseCase installApkUseCase(Ref ref) {
  return InstallApkUseCase(ref.read(appUpdateRepositoryProvider));
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
GetDeliveryForSupplyRequestUseCase getDeliveryForSupplyRequestUseCase(Ref ref) {
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
InitializePushNotificationUseCase initializePushNotificationUseCase(Ref ref) {
  return InitializePushNotificationUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetInitialPushNotificationMessageUseCase
getInitialPushNotificationMessageUseCase(Ref ref) {
  return GetInitialPushNotificationMessageUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetNotificationPayloadUseCase getNotificationPayloadUseCase(Ref ref) {
  return GetNotificationPayloadUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetNotificationPayloadStreamUseCase getNotificationPayloadStreamUseCase(
  Ref ref,
) {
  return GetNotificationPayloadStreamUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetNotificationsEnabledUseCase getNotificationsEnabledUseCase(Ref ref) {
  return GetNotificationsEnabledUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
SetNotificationsEnabledUseCase setNotificationsEnabledUseCase(Ref ref) {
  return SetNotificationsEnabledUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
GetDisabledNotificationChannelsUseCase getDisabledNotificationChannelsUseCase(
  Ref ref,
) {
  return GetDisabledNotificationChannelsUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
}

@riverpod
SetNotificationChannelEnabledUseCase setNotificationChannelEnabledUseCase(
  Ref ref,
) {
  return SetNotificationChannelEnabledUseCase(
    ref.read(pushNotificationRepositoryProvider),
  );
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

@riverpod
GetProfileUseCase getProfileUseCase(Ref ref) {
  return GetProfileUseCase(repository: ref.read(profileRepositoryProvider));
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) {
  return UpdateProfileUseCase(repository: ref.read(profileRepositoryProvider));
}


