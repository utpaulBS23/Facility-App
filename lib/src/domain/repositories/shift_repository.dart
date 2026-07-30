import '../../core/base/base.dart';
import '../entities/shift_entity.dart';
import '../entities/shift_slot_entity.dart';
import '../entities/shift_template_entity.dart';

abstract base class ShiftRepository extends Repository {
  Future<Result<ShiftGlobalConfigEntity, Failure>> getShiftGlobalConfig();

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

  Future<Result<void, Failure>> assignShiftSlot({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  });

  Future<Result<void, Failure>> unassignShiftSlot({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  });

  Future<Result<void, Failure>> makeSlotLead({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int assignmentId,
  });

  Future<Result<RosterEntity, Failure>> createRoster({
    required int partnerId,
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  });

  Future<Result<RosterListEntity, Failure>> getRosters({
    required int partnerId,
    required int facilityId,
    int? page,
  });

  Future<Result<RosterEntity, Failure>> publishRoster({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  });

  Future<Result<ShiftEntity, Failure>> createShift({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  });

  Future<Result<RosterShiftsEntity, Failure>> getRosterShifts({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  });

  Future<Result<List<ShiftTemplateEntity>, Failure>> getShiftTemplates({
    required int partnerId,
  });
}
