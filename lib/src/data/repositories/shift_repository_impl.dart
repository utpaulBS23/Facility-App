import '../../core/base/base.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/shift_slot_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../extension/roster_mapper.dart';
import '../extension/roster_shift_mapper.dart';
import '../extension/shift_mapper.dart';
import '../extension/shift_slot_mapper.dart';
import '../models/roster_model.dart';
import '../models/roster_shift_model.dart';
import '../models/shift_model.dart';
import '../models/shift_slot_model.dart';
import '../services/network/rest_client.dart';

final class ShiftRepositoryImpl extends ShiftRepository {
  ShiftRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<ShiftSlotsEntity, Failure>> getShiftSlots({
    required int partnerId,
    required int facilityId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await remote.getShiftSlots(
        partnerId: partnerId,
        facilityId: facilityId,
        date: date,
      );
      final model = ShiftSlotsResponseModel.fromJson(response.data);
      final data = model.data;
      if (data == null) {
        throw const FormatException('Shift slots response had no data');
      }
      return data.toEntity();
    });
  }

  @override
  Future<Result<List<ShiftEntity>, Failure>> getMyShifts({
    required int partnerId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await remote.getMyShifts(
        partnerId: partnerId,
        date: date,
      );
      final model = ShiftResponseModel.fromJson(response.data);
      return model.data.map((s) => s.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<ShiftEntity>, Failure>> getSupervisorShifts({
    required int partnerId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await remote.getSupervisorShifts(
        partnerId: partnerId,
        date: date,
      );
      final model = ShiftResponseModel.fromJson(response.data);
      return model.data.map((s) => s.toEntity()).toList();
    });
  }

  @override
  Future<Result<void, Failure>> assignShiftSlot({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  }) {
    return asyncGuard(() async {
      await remote.assignShiftSlot(
        partnerId: partnerId,
        facilityId: facilityId,
        rosterId: rosterId,
        request: {
          'attendant_id': attendantId,
          'shift_slot_id': shiftSlotId,
          'is_slot_lead': isSlotLead,
        },
      );
    });
  }

  @override
  Future<Result<RosterEntity, Failure>> createRoster({
    required int partnerId,
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  }) {
    return asyncGuard(() async {
      final response = await remote.createRoster(
        partnerId: partnerId,
        facilityId: facilityId,
        request: {
          'week_start_date': weekStartDate,
          'week_end_date': weekEndDate,
          'off_days': offDays,
        },
      );
      final model = RosterResponseModel.fromJson(response.data);
      final data = model.data;
      if (data == null) {
        throw const FormatException('Create roster response had no data');
      }
      return data.toEntity();
    });
  }

  @override
  Future<Result<RosterListEntity, Failure>> getRosters({
    required int partnerId,
    required int facilityId,
    int? page,
  }) {
    return asyncGuard(() async {
      final response = await remote.getRosters(
        partnerId: partnerId,
        facilityId: facilityId,
        page: page,
      );
      final model = RosterListResponseModel.fromJson(response.data);
      return model.toEntity();
    });
  }

  @override
  Future<Result<RosterEntity, Failure>> publishRoster({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  }) {
    return asyncGuard(() async {
      final response = await remote.publishRoster(
        partnerId: partnerId,
        facilityId: facilityId,
        rosterId: rosterId,
      );
      final model = RosterResponseModel.fromJson(response.data);
      final data = model.data;
      if (data == null) {
        throw const FormatException('Publish roster response had no data');
      }
      return data.toEntity();
    });
  }

  @override
  Future<Result<ShiftEntity, Failure>> createShift({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  }) {
    return asyncGuard(() async {
      final response = await remote.createShift(
        partnerId: partnerId,
        facilityId: facilityId,
        rosterId: rosterId,
        request: {
          'shift_template_id': shiftTemplateId,
          'shift_date': shiftDate,
          'notes': notes,
          'min_attendants': minAttendants,
          'max_attendants': maxAttendants,
        },
      );
      final model = CreateShiftResponseModel.fromJson(response.data);
      final data = model.data;
      if (data == null) {
        throw const FormatException('Create shift response had no data');
      }
      return data.toEntity();
    });
  }

  @override
  Future<Result<RosterShiftsEntity, Failure>> getRosterShifts({
    required int partnerId,
    required int facilityId,
    required int rosterId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getRosterShifts(
        partnerId: partnerId,
        facilityId: facilityId,
        rosterId: rosterId,
      );
      final model = RosterShiftsResponseModel.fromJson(response.data);
      return model.toEntity();
    });
  }
}
