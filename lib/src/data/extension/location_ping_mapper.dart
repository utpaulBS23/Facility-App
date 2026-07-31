import '../../domain/entities/location_ping_entity.dart';

extension LocationPingSyncRequestMapper on LocationPingSyncRequestEntity {
  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'pings': pings.map((ping) => ping.toJson()).toList(),
    };
  }
}

extension LocationPingMapper on LocationPingEntity {
  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      'recorded_at': recordedAt.toUtc().toIso8601String(),
      if (battery != null) 'battery': battery,
    };
  }
}
