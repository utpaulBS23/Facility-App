import '../../../../domain/entities/shift_slot_entity.dart';

class AssignStaffArgs {
  const AssignStaffArgs({
    required this.slot,
    required this.facilityId,
  });

  final ShiftSlotEntity slot;
  final int facilityId;
}