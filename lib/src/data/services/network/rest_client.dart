import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'endpoints.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Endpoints.base)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl, ParseErrorLogger errorLogger}) =
      _RestClient;

  @POST(Endpoints.login)
  Future<HttpResponse> login(@Body() Map<String, dynamic> request);

  @DELETE(Endpoints.logout)
  Future<HttpResponse> logout();

  @GET(Endpoints.versionCheck)
  Future<HttpResponse> checkVersion({
    @Query('device_id') required String deviceId,
    @Query('device_model') String? deviceModel,
    @Query('os_version') String? osVersion,
    @Query('current_version_code') required int currentVersionCode,
  });

  @PATCH(Endpoints.updateAction)
  Future<HttpResponse> reportUpdateAction({
    @Body() required Map<String, dynamic> request,
  });

  @POST(Endpoints.checkIn)
  Future<HttpResponse> checkIn(
    @Path('partnerId') int partnerId,
    @Body() FormData formData,
  );

  @POST(Endpoints.checkOut)
  Future<HttpResponse> checkOut(
    @Path('partnerId') int partnerId,
    @Body() FormData formData,
  );

  @GET(Endpoints.shiftSlots)
  Future<HttpResponse> getShiftSlots({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') required int facilityId,
    @Query('date') required String date,
  });

  @GET(Endpoints.shiftGlobalConfig)
  Future<HttpResponse> getShiftGlobalConfig();

  @GET(Endpoints.myShifts)
  Future<HttpResponse> getMyShifts({
    @Path('partnerId') required int partnerId,
    @Query('date') required String date,
  });

  @GET(Endpoints.supervisorShifts)
  Future<HttpResponse> getSupervisorShifts({
    @Path('partnerId') required int partnerId,
    @Query('date') required String date,
  });

  @GET(Endpoints.partnerUsers)
  Future<HttpResponse> getPartnerUsers({
    @Path('partnerId') required int partnerId,
  });

  @POST(Endpoints.assignShiftSlot)
  Future<HttpResponse> assignShiftSlot({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
    @Body() required Map<String, dynamic> request,
  });

  @DELETE(Endpoints.unassignShiftSlot)
  Future<HttpResponse> unassignShiftSlot({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
    @Path('assignmentId') required int assignmentId,
  });

  // WHY no body: the backend takes no request payload on this action — the
  // promoted attendant is implied entirely by which assignment id is PATCHed.
  @PATCH(Endpoints.makeSlotLead)
  Future<HttpResponse> makeSlotLead({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
    @Path('assignmentId') required int assignmentId,
  });

  @POST(Endpoints.createRoster)
  Future<HttpResponse> createRoster({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.getRosters)
  Future<HttpResponse> getRosters({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Query('page') int? page,
  });

  @POST(Endpoints.publishRoster)
  Future<HttpResponse> publishRoster({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
  });

  @POST(Endpoints.createShift)
  Future<HttpResponse> createShift({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.getRosterShifts)
  Future<HttpResponse> getRosterShifts({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
  });

  @GET(Endpoints.shiftTemplates)
  Future<HttpResponse> getShiftTemplates({
    @Path('partnerId') required int partnerId,
  });

  @POST(Endpoints.manualAttendance)
  Future<HttpResponse> submitManualAttendance({
    @Path('partnerId') required int partnerId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.manualAttendanceRefresh)
  Future<HttpResponse> refreshAttendance({
    @Path('partnerId') required int partnerId,
    @Query('shift_id') required int shiftId,
  });

  @DELETE(Endpoints.manualAttendanceWithdraw)
  Future<HttpResponse> withdrawAttendance({
    @Path('partnerId') required int partnerId,
    @Path('attendanceId') required int attendanceId,
  });

  @GET(Endpoints.monthlyAttendanceOverview)
  Future<HttpResponse> getMonthlyAttendanceOverview({
    @Path('partnerId') required int partnerId,
    @Query('month') required String month,
    @Query('facility_id') int? facilityId,
    @Query('user_id') int? userId,
  });

  @POST(Endpoints.approveAttendance)
  Future<HttpResponse> approveAttendance({
    @Path('partnerId') required int partnerId,
    @Path('attendanceId') required int attendanceId,
  });

  @POST(Endpoints.rejectAttendance)
  Future<HttpResponse> rejectAttendance({
    @Path('partnerId') required int partnerId,
    @Path('attendanceId') required int attendanceId,
  });

  // Visits — BHUM-259
  @GET(Endpoints.myVisits)
  Future<HttpResponse> getMyVisits({
    @Path('partnerId') required int partnerId,
    @Query('date') required String date,
  });

  @GET(Endpoints.visitDetail)
  Future<HttpResponse> getVisitDetail({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
  });

  @POST(Endpoints.visitCheckIn)
  Future<HttpResponse> checkInVisit({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.visitChecklist)
  Future<HttpResponse> getChecklist({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
  });

  @POST(Endpoints.visitSubmit)
  Future<HttpResponse> submitVisit({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
  });

  @POST(Endpoints.visitChecklistItemResponse)
  Future<HttpResponse> saveChecklistItemResponse({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
    @Path('itemId') required int itemId,
    @Body() required FormData formData,
  });

  @POST(Endpoints.reportIssue)
  Future<HttpResponse> reportIssue({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
    @Body() required FormData request,
  });

  @POST(Endpoints.locationPingSync)
  Future<HttpResponse> syncLocationPings({
    @Path('partnerId') required int partnerId,
    @Body() required Map<String, dynamic> request,
  });

  @POST(Endpoints.travelRouteCheckIn)
  Future<HttpResponse> travelRouteCheckIn({
    @Path('partnerId') required int partnerId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.issues)
  Future<HttpResponse> getIssues({
    @Path('partnerId') required int partnerId,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('facility_id') int? facilityId,
    @Query('assigned_to') int? assignedTo,
    @Query('per_page') int? perPage,
    @Query('page') int? page,
  });

  @GET(Endpoints.issueDetail)
  Future<HttpResponse> getIssueDetail({
    @Path('partnerId') required int partnerId,
    @Path('issueId') required int issueId,
  });

  @GET(Endpoints.problemCategories)
  Future<HttpResponse> getProblemCategories({
    @Path('partnerId') required int partnerId,
    @Query('category') String category = 'issueProblemCategory',
  });

  @POST(Endpoints.startIssue)
  Future<HttpResponse> startIssue({
    @Path('partnerId') required int partnerId,
    @Path('issueId') required int issueId,
  });

  @POST(Endpoints.completeIssue)
  Future<HttpResponse> completeIssue({
    @Path('partnerId') required int partnerId,
    @Path('issueId') required int issueId,
  });

  @POST(Endpoints.taskMedia)
  Future<HttpResponse> uploadTaskMedia({
    @Path('partnerId') required int partnerId,
    @Path('taskId') required int taskId,
    @Body() required FormData formData,
  });

  /// Leave Management
  @GET(Endpoints.leavePolicies)
  Future<HttpResponse> getLeavePolicies({
    @Path('partnerId') required int partnerId,
  });

  @GET(Endpoints.leaveBalances)
  Future<HttpResponse> getLeaveBalances({
    @Path('partnerId') required int partnerId,
    @Query('year') int? year,
    @Query('leave_policy_id') int? leavePolicyId,
    @Query('attendant_id') int? attendantId,
  });

  @POST(Endpoints.requestLeave)
  Future<HttpResponse> requestLeave({
    @Path('partnerId') required int partnerId,
    @Body() required Map<String, dynamic> body,
  });

  @GET(Endpoints.myLeaves)
  Future<HttpResponse> getMyLeaves({
    @Path('partnerId') required int partnerId,
    @Query('status') String? status,
  });

  @GET(Endpoints.leaveRequestDetails)
  Future<HttpResponse> getLeaveRequestDetails({
    @Path('partnerId') required int partnerId,
    @Path('leaveRequestId') required int leaveRequestId,
  });

  @POST(Endpoints.cancelLeave)
  Future<HttpResponse> cancelLeave({
    @Path('partnerId') required int partnerId,
    @Path('leaveRequestId') required int leaveRequestId,
  });

  @GET(Endpoints.leaveAttendants)
  Future<HttpResponse> getLeaveAttendants({
    @Path('partnerId') required int partnerId,
  });

  @GET(Endpoints.leaveApprovals)
  Future<HttpResponse> getLeaveApprovals({
    @Path('partnerId') required int partnerId,
    @Query('status') String? status,
  });

  @POST(Endpoints.approveLeave)
  Future<HttpResponse> approveLeave({
    @Path('partnerId') required int partnerId,
    @Path('leaveRequestId') required int leaveRequestId,
  });

  @POST(Endpoints.rejectLeave)
  Future<HttpResponse> rejectLeave({
    @Path('partnerId') required int partnerId,
    @Path('leaveRequestId') required int leaveRequestId,
    @Body() required Map<String, dynamic> body,
  });

  /// Supply & Stock Management
  @GET(Endpoints.itemCatalog)
  Future<HttpResponse> getItemCatalog({
    @Path('partnerId') required int partnerId,
    @Query('search') String? search,
    @Query('category') String? category,
    @Query('is_active') bool? isActive,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET(Endpoints.supplyRequests)
  Future<HttpResponse> getSupplyRequests({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('status') String? status,
    @Query('urgency') String? urgency,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET(Endpoints.supplyRequestSummary)
  Future<HttpResponse> getSupplyRequestSummary({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
  });

  @GET(Endpoints.supplyRequestDetails)
  Future<HttpResponse> getSupplyRequestDetails({
    @Path('partnerId') required int partnerId,
    @Path('supplyRequestId') required int supplyRequestId,
  });

  @POST(Endpoints.supplyRequests)
  Future<HttpResponse> createSupplyRequest({
    @Path('partnerId') required int partnerId,
    @Body() required Map<String, dynamic> body,
  });

  @POST(Endpoints.approveSupplyRequest)
  Future<HttpResponse> approveSupplyRequest({
    @Path('partnerId') required int partnerId,
    @Path('supplyRequestId') required int supplyRequestId,
    @Body() Map<String, dynamic> body = const {},
  });

  @POST(Endpoints.rejectSupplyRequest)
  Future<HttpResponse> rejectSupplyRequest({
    @Path('partnerId') required int partnerId,
    @Path('supplyRequestId') required int supplyRequestId,
    @Body() Map<String, dynamic> body = const {},
  });

  @POST(Endpoints.dispatchSupplyRequest)
  Future<HttpResponse> dispatchSupplyRequest({
    @Path('partnerId') required int partnerId,
    @Path('supplyRequestId') required int supplyRequestId,
    @Body() Map<String, dynamic> body = const {},
  });

  @GET(Endpoints.deliveries)
  Future<HttpResponse> getDeliveries({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET(Endpoints.deliveryDetails)
  Future<HttpResponse> getDeliveryDetails({
    @Path('partnerId') required int partnerId,
    @Path('deliveryId') required int deliveryId,
  });

  @POST(Endpoints.confirmDelivery)
  Future<HttpResponse> confirmDelivery({
    @Path('partnerId') required int partnerId,
    @Path('deliveryId') required int deliveryId,
    @Body() Map<String, dynamic> body = const {},
  });

  @GET(Endpoints.deliveryComplaints)
  Future<HttpResponse> getDeliveryComplaints({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET(Endpoints.deliveryComplaintDetails)
  Future<HttpResponse> getDeliveryComplaintDetails({
    @Path('partnerId') required int partnerId,
    @Path('deliveryComplaintId') required int deliveryComplaintId,
  });

  @POST(Endpoints.fileDeliveryComplaint)
  Future<HttpResponse> fileDeliveryComplaint({
    @Path('partnerId') required int partnerId,
    @Path('deliveryId') required int deliveryId,
    @Body() required Map<String, dynamic> body,
  });

  @POST(Endpoints.approveDeliveryComplaint)
  Future<HttpResponse> approveDeliveryComplaint({
    @Path('partnerId') required int partnerId,
    @Path('deliveryComplaintId') required int deliveryComplaintId,
    @Body() Map<String, dynamic> body = const {},
  });

  @POST(Endpoints.rejectDeliveryComplaint)
  Future<HttpResponse> rejectDeliveryComplaint({
    @Path('partnerId') required int partnerId,
    @Path('deliveryComplaintId') required int deliveryComplaintId,
    @Body() Map<String, dynamic> body = const {},
  });

  @GET(Endpoints.stockAllocations)
  Future<HttpResponse> getStockAllocations({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET(Endpoints.stockAllocationDetails)
  Future<HttpResponse> getStockAllocationDetails({
    @Path('partnerId') required int partnerId,
    @Path('stockAllocationId') required int stockAllocationId,
  });

  @POST(Endpoints.submitShiftStockCount)
  Future<HttpResponse> submitShiftStockCount({
    @Path('partnerId') required int partnerId,
    @Path('shiftAssignmentId') required int shiftAssignmentId,
    @Body() required Map<String, dynamic> body,
  });

  @GET(Endpoints.shiftStockCounts)
  Future<HttpResponse> getShiftStockCounts({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('shift_assignment_id') int? shiftAssignmentId,
    @Query('stock_item_id') int? stockItemId,
    @Query('from') String? from,
    @Query('to') String? to,
  });

  @GET(Endpoints.facilityStockBalance)
  Future<HttpResponse> getFacilityStockBalance({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') int? facilityId,
    @Query('stock_item_id') int? stockItemId,
    @Query('status') String? status,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// Task Occurrences
  @GET(Endpoints.taskOccurrences)
  Future<HttpResponse> getTaskOccurrences({
    @Path('partnerId') required int partnerId,
    @Query('facility_id') required int facilityId,
    @Query('date') String? date,
  });

  @PATCH(Endpoints.taskOccurrenceReassign)
  Future<HttpResponse> reassignTaskOccurrence({
    @Path('partnerId') required int partnerId,
    @Path('taskOccurrenceId') required int taskOccurrenceId,
    @Body() required Map<String, dynamic> request,
  });

  @POST(Endpoints.taskOccurrenceChecklistItemResponse)
  Future<HttpResponse> answerTaskOccurrenceChecklistItem({
    @Path('partnerId') required int partnerId,
    @Path('taskOccurrenceId') required int taskOccurrenceId,
    @Path('itemId') required int itemId,
    @Body() required FormData formData,
  });

  @PATCH(Endpoints.taskOccurrenceSubmit)
  Future<HttpResponse> submitTaskOccurrence({
    @Path('partnerId') required int partnerId,
    @Path('taskOccurrenceId') required int taskOccurrenceId,
    @Body() Map<String, dynamic> request = const {},
  });
}

