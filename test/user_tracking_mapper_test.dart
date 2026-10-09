import 'package:facility_management_app/src/data/extension/user_tracking_mapper.dart';
import 'package:facility_management_app/src/data/models/live_position/live_position_model.dart';
import 'package:facility_management_app/src/domain/entities/user_tracking_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a page of live positions', () {
    final page = LivePositionsResponseModel.fromJson({
      'data': [
        {
          'user_id': 117,
          'name': 'Shakib',
          'lat': 23.8103,
          'lng': 90.4125,
          'accuracy_meters': 12.5,
          'task_id': 1042,
          'facility': {'id': 68, 'name': 'Brainstation 23 Facility'},
          'office': null,
          'recorded_at': '2026-10-05T10:15:45+00:00',
          'battery_level': 77,
          'online': true,
          'activity': 'On-site — checked in',
          'within_geofence': true,
        },
        {
          'user_id': 118,
          'name': 'Shahin',
          'lat': 23.78,
          'lng': 90.27,
          'accuracy_meters': null,
          'facility': null,
          'recorded_at': '2026-10-05T09:40:10+00:00',
          'battery_level': null,
          'online': false,
          'activity': 'Something new',
          'within_geofence': null,
        },
        {'user_id': 119, 'name': 'No pin', 'lat': null, 'lng': null},
        {'user_id': 120, 'name': 'Zero', 'lat': 0, 'lng': 0},
      ],
      'links': {'next': 'http://x/live-positions?page=2'},
    }).toEntity();

    expect(page.hasNext, isTrue);
    expect(page.positions.map((p) => p.userId), [117, 118]);

    final first = page.positions[0];
    expect(first.facilityName, 'Brainstation 23 Facility');
    expect(first.accuracyMeters, 12.5);
    expect(first.batteryLevel, 77);
    expect(first.online, isTrue);
    expect(first.activity, UserActivity.onSite);
    expect(first.withinGeofence, isTrue);
    expect(first.recordedAt.isUtc, isTrue);

    final second = page.positions[1];
    expect(second.facilityName, '');
    expect(second.accuracyMeters, isNull);
    expect(second.batteryLevel, isNull);
    expect(second.withinGeofence, isNull);
    // Unknown text keeps the server's wording.
    expect(second.activity, UserActivity.unknown);
    expect(second.activityText, 'Something new');
  });

  test('the last page has no next link', () {
    final page = LivePositionsResponseModel.fromJson({
      'data': <Map<String, dynamic>>[],
      'links': {'next': null},
    }).toEntity();

    expect(page.hasNext, isFalse);
    expect(page.positions, isEmpty);
  });

  test('counts online and offline users', () {
    UserPositionEntity user(int id, bool online) => UserPositionEntity(
      userId: id,
      name: 'u$id',
      lat: 1,
      lng: 1,
      recordedAt: DateTime.utc(2026),
      online: online,
      activity: UserActivity.idle,
    );
    final entity = UserTrackingEntity(
      positions: [user(1, true), user(2, false), user(3, false)],
    );

    expect(entity.onlineCount, 1);
    expect(entity.offlineCount, 2);
  });
}
