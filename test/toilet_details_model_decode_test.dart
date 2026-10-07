import 'dart:convert';

import 'package:facility_management_app/src/data/extension/toilet_location_mapper.dart';
import 'package:facility_management_app/src/data/models/toilet_location/toilet_details_model.dart';
import 'package:facility_management_app/src/domain/entities/toilet_location/toilet_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';

// The facility details response of facility 43, trimmed.
const _json = '''
{"id":43,"partner_id":7,"name":"Uttara North Facility",
"code":{"value":"IDTL-001","is_placeholder":true},
"distance_km":{"value":1.2,"is_placeholder":true},
"consumer_access":{"today":3,"this_week":9,"this_month":40,
 "hourly":[{"hour":0,"count":0,"is_peak":false},{"hour":9,"count":3,"is_peak":true}],
 "peak_hours_label":"9 AM"},
"income_target_and_goal":{"daily_target":500,"today_achieved":120,"monthly_target":15000,"month_achieved":900},
"monthly_progress":{"month":"2026-10","target":15000,"achieved":900,"remaining":14100,"percent_complete":6,"days_left":24,"daily_pace_needed":587.5},
"management_information":{
 "air_quality":{"value":0,"label":"Unknown","is_placeholder":true},
 "cleaning_frequency":{"value":null,"label":null,"is_placeholder":true},
 "last_cleaning_at":{"value":null,"is_placeholder":true},
 "real_time_air_tracking_enabled":false},
"supply_stock":[{"stock_item_id":5,"item_name":"Toilet Tissue Roll","unit":"roll","current_qty":6,"status":"low"},{"stock_item_id":6,"item_name":"Hand Wash","unit":"bottle","current_qty":0,"status":"out"}],
"attendance":{"shifts":[],"summary":{"present":1,"late":1,"not_checked_in":2,"total":4},
 "staff":[{"name":"Rahim Uddin","phone":"01712345001","role":"Attendant","status":"late","check_in_time":"2026-10-07T00:10:00Z"}]},
"images":[]}
''';

void main() {
  final d = ToiletDetailsModel.fromJson(jsonDecode(_json)).toEntity();

  test('reads the numbers, the hours and the goal', () {
    expect(d.id, 43);
    expect(d.visitsToday, 3);
    expect(d.visitsThisWeek, 9);
    expect(d.visitsThisMonth, 40);
    expect(d.hourly.length, 2);
    expect(d.hourly.last.isPeak, isTrue);
    expect(d.peakHoursLabel, '9 AM');
    expect(d.dailyTarget, 500);
    expect(d.monthAchieved, 900);
    expect(d.percentComplete, 6);
    expect(d.progressRemaining, 14100);
    expect(d.daysLeft, 24);
    expect(d.hasProgressTarget, isTrue);
  });

  test('placeholders are not shown as values', () {
    expect(d.code, isNull);
    expect(d.distanceKm, isNull);
    expect(d.airQuality, isNull);
    expect(d.cleaningFrequency, isNull);
    expect(d.lastCleaningAt, isNull);
  });

  test('reads stock and staff', () {
    expect(d.supplyStock.map((s) => s.level), [
      ToiletSupplyLevel.low,
      ToiletSupplyLevel.out,
    ]);
    expect(d.supplyStock.first.name, 'Toilet Tissue Roll');
    expect(d.supplyStock.first.unit, 'roll');
    expect(d.supplyStock.first.quantity, 6);
    expect(d.present, 1);
    expect(d.late, 1);
    expect(d.notCheckedIn, 2);
    expect(d.staff.single.name, 'Rahim Uddin');
    expect(d.staff.single.status, ToiletStaffStatus.late);
  });

  test('a missing section falls back to zero and empty', () {
    final e = ToiletDetailsModel.fromJson({'id': 1}).toEntity();
    expect(e.visitsToday, 0);
    expect(e.hourly, isEmpty);
    expect(e.hasProgressTarget, isFalse);
    expect(e.staff, isEmpty);
  });
}
