import '../../core/base/base.dart';
import '../entities/travel_route_entity.dart';

abstract base class TravelRouteRepository extends Repository {
  Future<Result<TravelRouteCheckInEntity, Failure>> checkIn({
    required int partnerId,
    required TravelRouteCheckInRequestEntity request,
  });
}
