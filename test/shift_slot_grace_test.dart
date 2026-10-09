import 'package:facility_management_app/src/data/extension/shift_slot_mapper.dart';
import 'package:facility_management_app/src/data/models/shift_slot_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the grace periods are read from the slot', () {
    final slot = ShiftSlotModel.fromJson({
      'shift_slot_id': 1,
      'start_time': '06:00:00',
      'end_time': '14:00:00',
      'check_in_window_after_minutes': 15,
      'check_out_window_after_minutes': 30,
    }).toEntity();

    expect(slot.checkInWindowAfterMinutes, 15);
    expect(slot.checkOutWindowAfterMinutes, 30);
  });

  test('a slot without them gets 60 minutes', () {
    final slot = ShiftSlotModel.fromJson({'shift_slot_id': 1}).toEntity();

    expect(slot.checkInWindowAfterMinutes, 60);
    expect(slot.checkOutWindowAfterMinutes, 60);
  });
}
