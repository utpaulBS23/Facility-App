/// What a user is doing right now, from the server's activity text.
enum UserActivity { idle, onShift, onSite, visitCompleted, traveling, unknown }

/// A user's last known position and state.
class UserPositionEntity {
  const UserPositionEntity({
    required this.userId,
    required this.name,
    required this.lat,
    required this.lng,
    this.facilityName = '',
    this.accuracyMeters,
    this.batteryLevel,
    required this.recordedAt,
    required this.online,
    required this.activity,
    this.activityText = '',
    this.withinGeofence,
  });

  final int userId;
  final String name;
  final double lat;
  final double lng;

  /// Empty when the user has no active facility ("Unassigned").
  final String facilityName;
  final double? accuracyMeters;
  final int? batteryLevel;
  final DateTime recordedAt;
  final bool online;
  final UserActivity activity;

  /// The server's text, shown as is when [activity] is [UserActivity.unknown].
  final String activityText;

  /// Null when there is nothing to measure against.
  final bool? withinGeofence;
}

/// One page of live positions.
class UserPositionsPageEntity {
  const UserPositionsPageEntity({
    required this.positions,
    required this.hasNext,
  });

  final List<UserPositionEntity> positions;
  final bool hasNext;
}

class UserTrackingEntity {
  const UserTrackingEntity({this.positions = const []});

  final List<UserPositionEntity> positions;

  int get onlineCount => positions.where((p) => p.online).length;
  int get offlineCount => positions.length - onlineCount;
}
