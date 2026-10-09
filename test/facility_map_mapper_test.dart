import 'package:facility_management_app/src/data/extension/facility_map_mapper.dart';
import 'package:facility_management_app/src/data/models/facility_map/facility_map_model.dart';
import 'package:facility_management_app/src/domain/entities/facility_map_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps only active facilities and attendants with a position', () {
    final entity = FacilityMapResponseModel.fromJson({
      'success': true,
      'data': {
        'facilities': [
          {'id': 1, 'name': 'A', 'status': 'active', 'lat': 23.7, 'lng': 90.4},
          {'id': 2, 'name': 'B', 'status': 'maintenance', 'lat': 1, 'lng': 2},
          {'id': 3, 'name': 'C', 'status': 'active', 'lat': null, 'lng': null},
          {'id': 4, 'name': 'D', 'status': 'active', 'lat': 0, 'lng': 0},
        ],
        'staff': [
          {
            'id': 10,
            'uid': 'u1',
            'name': 'Sarah',
            'status': 'working',
            'lat': 23.7,
            'lng': 90.4,
            'facilities': [
              {'id': 1, 'name': 'A'},
            ],
          },
          {'id': 11, 'name': 'No pin', 'lat': null, 'lng': null},
          {
            'id': 12,
            'name': 'Ended',
            'status': 'contract_ended',
            'lat': 1,
            'lng': 2,
          },
          {'id': 13, 'name': 'Odd', 'status': 'something', 'lat': 1, 'lng': 2},
        ],
      },
      'summary': {'working': 4, 'free': 9, 'contract_ended': 1},
    }).toEntity();

    expect(entity.facilities.map((f) => f.id), [1]);
    expect(entity.staff.map((s) => s.id), [10, 12, 13]);
    expect(entity.staff[0].status, StaffPinStatus.working);
    expect(entity.staff[0].facilityId, 1);
    expect(entity.staff[1].status, StaffPinStatus.contractEnded);
    // Unknown status falls back to free.
    expect(entity.staff[2].status, StaffPinStatus.free);
    expect(entity.summary.working, 4);
    expect(entity.summary.free, 9);
    expect(entity.summary.contractEnded, 1);
  });

  test('an empty response maps to an empty map', () {
    final entity = FacilityMapResponseModel.fromJson({
      'success': true,
    }).toEntity();
    expect(entity.facilities, isEmpty);
    expect(entity.staff, isEmpty);
    expect(entity.summary.working, 0);
  });
}
