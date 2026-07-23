import '../../core/base/base.dart';
import '../entities/shift_entity.dart';
import '../entities/shift_slot_entity.dart';

abstract base class ShiftRepository extends Repository {
  /// Facility-and-date scoped slots serving both experiences — supersedes
  /// [getMyShifts] and [getSupervisorShifts].
  Future<Result<ShiftSlotsEntity, Failure>> getShiftSlots({
    required int partnerId,
    required int facilityId,
    required String date,
  });

  Future<Result<List<ShiftEntity>, Failure>> getMyShifts({
    required int partnerId,
    required String date,
  });

  Future<Result<List<ShiftEntity>, Failure>> getSupervisorShifts({
    required int partnerId,
    required String date,
  });
}
