import '../../domain/entities/user_route_entity.dart';
import '../models/user_route/user_route_model.dart';

extension RouteLegModelToEntity on RouteLegModel {
  RouteLegEntity toEntity() => RouteLegEntity(
    id: routeLegId,
    fromName: fromFacility?.name ?? '',
    toName: toFacility?.name ?? '',
    fromTime: DateTime.tryParse(fromTime ?? '')?.toLocal(),
    toTime: DateTime.tryParse(toTime ?? '')?.toLocal(),
    trail: [
      for (final p in trail)
        if (p.lat != null && p.lng != null)
          RoutePointEntity(lat: p.lat!.toDouble(), lng: p.lng!.toDouble()),
    ],
    hasTravelExpense: travelExpenseId != null,
  );
}

extension UserRouteResponseModelToEntity on UserRouteResponseModel {
  UserRouteEntity toEntity() => UserRouteEntity(
    legs: [
      for (final leg in data?.legs ?? const <RouteLegModel>[]) leg.toEntity(),
    ],
  );
}
