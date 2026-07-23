import '../../core/base/base.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/entities/shift_slot_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../extension/shift_mapper.dart';
import '../extension/shift_slot_mapper.dart';
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
}
