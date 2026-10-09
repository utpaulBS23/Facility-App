import 'package:facility_management_app/src/data/extension/user_route_mapper.dart';
import 'package:facility_management_app/src/data/models/user_route/user_route_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps legs with trails and travel expense flag', () {
    final route = UserRouteResponseModel.fromJson({
      'success': true,
      'message': 'User route retrieved successfully.',
      'data': {
        'user_id': 117,
        'date': '2026-10-05',
        'legs': [
          {
            'route_leg_id': 1043,
            'from_facility': {'id': 68, 'name': 'Brainstation 23 Facility'},
            'to_facility': {'id': 71, 'name': 'Gulshan Public Toilet'},
            'from_time': '2026-10-05T11:02:10+00:00',
            'to_time': '2026-10-05T11:34:55+00:00',
            'trail': [
              {
                'lat': 23.7806,
                'lng': 90.4193,
                'recorded_at': '2026-10-05T11:05:00+00:00',
              },
              {'lat': null, 'lng': 90.4, 'recorded_at': null},
              {
                'lat': 23.779,
                'lng': 90.417,
                'recorded_at': '2026-10-05T11:15:00+00:00',
              },
            ],
            'travel_expense_id': 318,
          },
          {
            'route_leg_id': 1044,
            'from_facility': null,
            'to_facility': null,
            'from_time': null,
            'to_time': '2026-10-05T13:00:00+00:00',
            'trail': [],
            'travel_expense_id': null,
          },
        ],
      },
    }).toEntity();

    expect(route.legs, hasLength(2));
    final first = route.legs.first;
    expect(first.id, 1043);
    expect(first.fromName, 'Brainstation 23 Facility');
    expect(first.toName, 'Gulshan Public Toilet');
    expect(first.trail, hasLength(2), reason: 'drops pings without coords');
    expect(first.hasTravelExpense, isTrue);

    final open = route.legs.last;
    expect(open.fromName, isEmpty);
    expect(open.fromTime, isNull);
    expect(open.trail, isEmpty);
    expect(open.hasTravelExpense, isFalse);
  });

  test('no legs maps to an empty route', () {
    final route = UserRouteResponseModel.fromJson({
      'success': true,
      'data': {'user_id': 1, 'date': '2026-10-05', 'legs': []},
    }).toEntity();

    expect(route.legs, isEmpty);
  });
}
