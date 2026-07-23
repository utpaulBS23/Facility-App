import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_slot_entity.dart';

part 'shift_slots_provider.g.dart';

/// One facility's slots for one day. Feeds both shift experiences — the
/// supervisor view renders every slot, the attendant view renders
/// [ShiftSlotsEntity.mySlots] plus the active-slot call to action.
@riverpod
class ShiftSlots extends _$ShiftSlots {
  @override
  AsyncValue<ShiftSlotsEntity?> build() => const AsyncValue.data(null);

  Future<void> fetch({
    required int partnerId,
    required String date,
    int? facilityId,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<ShiftSlotsEntity, String> result = await ref
        .read(getShiftSlotsUseCaseProvider)
        .call(partnerId: partnerId, date: date, facilityId: facilityId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
