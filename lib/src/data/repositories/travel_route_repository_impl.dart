import '../../core/base/base.dart';
import '../../domain/entities/travel_route_entity.dart';
import '../../domain/repositories/travel_route_repository.dart';
import '../models/travel_route_model.dart';
import '../services/network/rest_client.dart';

final class TravelRouteRepositoryImpl extends TravelRouteRepository {
  TravelRouteRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<TravelRouteCheckInEntity, Failure>> checkIn({
    required int partnerId,
    required TravelRouteCheckInRequestEntity request,
  }) => asyncGuard(() async {
    final response = await _client.travelRouteCheckIn(
      partnerId: partnerId,
      request: {
        'task_id': request.taskId,
        'facility_id': request.facilityId,
        'lat': request.latitude,
        'lng': request.longitude,
      },
    );
    return TravelRouteCheckInResponseModel.fromJson(response.data).toEntity();
  });
}
