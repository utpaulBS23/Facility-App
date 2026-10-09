import 'package:facility_management_app/src/domain/entities/shift_slot_entity.dart';
import 'package:flutter_test/flutter_test.dart';

ShiftSlotEntity _slot(int id) => ShiftSlotEntity(
  shiftSlotId: id,
  startTime: '08:00',
  endTime: '16:00',
  durationHours: 8,
  slotStatus: 'open',
  assignedCount: 0,
  maxAttendants: 2,
  checkedInCount: 0,
  checkedOutCount: 0,
  supervisorName: '',
);

void main() {
  test('single-facility day finds slots and the facility', () {
    final day = ShiftSlotsEntity(
      date: '2026-10-06',
      day: 'Tue',
      facility: const SlotFacilityEntity(id: 44, name: 'A', address: ''),
      slots: [_slot(1), _slot(2)],
    );

    expect(day.findSlot(2)?.shiftSlotId, 2);
    expect(day.findSlot(9), isNull);
    expect(day.facilityIdOf(2), 44);
  });

  test('all-facilities day finds the slot in its group', () {
    final day = ShiftSlotsEntity(
      date: '2026-10-06',
      day: 'Tue',
      facilities: [
        SlotsFacilityEntity(
          facilityId: 7,
          facilityName: 'B',
          isPrimary: true,
          isRelief: false,
          slots: [_slot(5)],
        ),
        SlotsFacilityEntity(
          facilityId: 8,
          facilityName: 'C',
          isPrimary: false,
          isRelief: false,
          slots: [_slot(6)],
        ),
      ],
    );

    expect(day.findSlot(6)?.shiftSlotId, 6);
    expect(day.facilityIdOf(6), 8);
    expect(day.facilityIdOf(99), isNull);
  });
}
