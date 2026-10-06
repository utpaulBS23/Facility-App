import 'package:facility_management_app/src/data/extension/toilet_location_mapper.dart';
import 'package:facility_management_app/src/data/models/toilet_location/toilet_model.dart';
import 'package:flutter_test/flutter_test.dart';

// One facility of GET /partners/{id}/facilities, as the server sent it.
const _json = <String, dynamic>{
  'id': 43,
  'partner_id': 7,
  'partner_name': 'Abdul Monem Group',
  'name': 'Uttara North Facility',
  'name_bn': 'Uttara North Facility',
  'address': 'Uttara North Facility',
  'lat': 23,
  'lng': 90,
  'maps_link': null,
  'is_free': false,
  'disable_friendly': true,
  'status': 'active',
  'average_rating': 0,
  'facility_type': 'public',
  'operating_days': ['sat', 'sun', 'mon'],
  'supervisor': {'id': 79, 'name': 'Abdul Noman'},
  'visits_today': 5,
  'revenue': 120,
  'opening_time': '06:00:00',
  'closing_time': '22:00:00',
  'is_24_hours': false,
  'usage_fee': 10,
};

void main() {
  test('a facility keeps the details the details page shows', () {
    final t = ToiletModel.fromJson(_json).toEntity();

    expect(t.name, 'Uttara North Facility');
    expect(t.supervisorName, 'Abdul Noman');
    expect(t.openingTime, '06:00:00');
    expect(t.closingTime, '22:00:00');
    expect(t.operatingDays, ['sat', 'sun', 'mon']);
    expect(t.usageFee, 10);
    expect(t.disableFriendly, isTrue);
    expect(t.visitsToday, 5);
    expect(t.revenue, 120);
    expect(t.isFree, isFalse);
  });

  test('a facility with no supervisor or hours still decodes', () {
    final t = ToiletModel.fromJson({
      'id': 1,
      'name': 'A',
      'status': 'active',
      'supervisor': null,
    }).toEntity();

    expect(t.supervisorName, '');
    expect(t.operatingDays, isEmpty);
    expect(t.openingTime, isNull);
    expect(t.visitsToday, 0);
  });
}
