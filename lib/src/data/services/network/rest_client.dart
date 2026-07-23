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

  @POST(Endpoints.createRoster)
  Future<HttpResponse> createRoster({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Body() required Map<String, dynamic> request,
  });

  @POST(Endpoints.createShift)
  Future<HttpResponse> createShift({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
    @Path('rosterId') required int rosterId,
    @Body() required Map<String, dynamic> request,
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

  @POST(Endpoints.visitCheckInCapture)
  Future<HttpResponse> captureCheckIn({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.visitChecklist)
  Future<HttpResponse> getChecklist({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
  });

  @POST(Endpoints.visitChecklistSubmit)
  Future<HttpResponse> submitChecklist({
    @Path('partnerId') required int partnerId,
    @Path('visitId') required int visitId,
    @Body() required Map<String, dynamic> request,
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
    @Body() required Map<String, dynamic> request,
  });

  @GET(Endpoints.tasks)
  Future<HttpResponse> getTasks({
    @Path('partnerId') required int partnerId,
    @Query('bucket') required String bucket,
    @Query('task_type') required String taskType,
  });

  @GET(Endpoints.taskDetail)
  Future<HttpResponse> getTaskDetail({
    @Path('partnerId') required int partnerId,
    @Path('taskId') required int taskId,
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
}
