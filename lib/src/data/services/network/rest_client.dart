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

  @POST(Endpoints.faceValidation)
  Future<HttpResponse> validateFace(
    @Path('partnerId') int partnerId,
    @Body() FormData formData,
  );

  @POST(Endpoints.checkOut)
  Future<HttpResponse> checkOut(
    @Path('partnerId') int partnerId,
    @Body() FormData formData,
  );

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

  @GET(Endpoints.facilityAttendants)
  Future<HttpResponse> getFacilityAttendants({
    @Path('partnerId') required int partnerId,
    @Path('facilityId') required int facilityId,
  });
}
