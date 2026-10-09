/// One recorded GPS ping on a route.
class RoutePointEntity {
  const RoutePointEntity({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

/// One journey between two visits.
class RouteLegEntity {
  const RouteLegEntity({
    required this.id,
    this.fromName = '',
    this.toName = '',
    this.fromTime,
    this.toTime,
    this.trail = const [],
    this.hasTravelExpense = false,
  });

  final int id;

  /// Empty when the visit had no facility or office.
  final String fromName;
  final String toName;

  /// Null while the previous visit is still open.
  final DateTime? fromTime;
  final DateTime? toTime;

  /// Pings between [fromTime] and [toTime], oldest first. May be empty.
  final List<RoutePointEntity> trail;
  final bool hasTravelExpense;
}

/// A user's day, as legs. Empty when there was no travel.
class UserRouteEntity {
  const UserRouteEntity({this.legs = const []});

  final List<RouteLegEntity> legs;
}
