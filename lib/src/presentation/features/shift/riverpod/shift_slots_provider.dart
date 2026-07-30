import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
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

  Future<void> fetch({required String date, int? facilityId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<ShiftSlotsEntity, Failure> result = await ref
        .read(getShiftSlotsUseCaseProvider)
        .call(date: date, facilityId: facilityId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  /// Re-fetches the currently-loaded day/facility.
  ///
  /// WHY: several actions elsewhere on a slot (assign, unassign, make-lead)
  /// change assigned_count/attendants on this day's slots, so the cached list
  /// must be refetched rather than just left as-is. No-op if nothing has
  /// been fetched yet.
  void refresh() {
    final current = state.valueOrNull;
    if (current == null) return;
    fetch(date: current.date, facilityId: current.facility?.id);
  }
}
