import '../../domain/entities/user_tracking_entity.dart';
import '../models/live_position/live_position_model.dart';

UserActivity _activityOf(String? text) => switch (text) {
  'Idle' => UserActivity.idle,
  'On shift — checked in' => UserActivity.onShift,
  'On-site — checked in' => UserActivity.onSite,
  'Visit completed' ||
  'Facility visit completed' => UserActivity.visitCompleted,
  'Traveling to location' || 'Traveling to facility' => UserActivity.traveling,
  _ => UserActivity.unknown,
};

bool _hasPosition(num? lat, num? lng) =>
    lat != null && lng != null && !(lat == 0 && lng == 0);

extension LivePositionModelToEntity on LivePositionModel {
  UserPositionEntity toEntity() => UserPositionEntity(
    userId: userId,
    name: name ?? '',
    lat: lat!.toDouble(),
    lng: lng!.toDouble(),
    facilityName: facility?.name ?? '',
    accuracyMeters: accuracyMeters?.toDouble(),
    batteryLevel: batteryLevel?.round(),
    recordedAt: DateTime.tryParse(recordedAt ?? '') ?? DateTime.now(),
    online: online ?? false,
    activity: _activityOf(activity),
    activityText: activity ?? '',
    withinGeofence: withinGeofence,
  );
}

extension LivePositionsResponseModelToEntity on LivePositionsResponseModel {
  UserPositionsPageEntity toEntity() => UserPositionsPageEntity(
    positions: [
      for (final p in data)
        if (_hasPosition(p.lat, p.lng)) p.toEntity(),
    ],
    hasNext: links?.next != null,
  );
}
