import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../check_in_out/riverpod/check_in_provider.dart';
import '../../check_in_out/riverpod/check_out_provider.dart';
import 'assign_shift_slot_provider.dart';
import 'make_slot_lead_provider.dart';
import 'unassign_shift_slot_provider.dart';

part 'shift_slots_provider.g.dart';

/// One facility's slots for one day. Feeds both shift experiences — the
/// supervisor view renders every slot, the attendant view renders
/// [ShiftSlotsEntity.mySlots] plus the active-slot call to action.
@riverpod
class ShiftSlots extends _$ShiftSlots {
  @override
  AsyncValue<ShiftSlotsEntity?> build() {
    // WHY self-refresh here rather than each caller invalidating this
    // provider after the fact: every action below changes this day's slots
    // (assigned_count, attendants, check-in/out state) — listening once in
    // the data provider itself means a new caller can't forget to wire it.
    ref.listen(checkInProvider, (_, next) {
      if (next is AsyncData && next.value is Success) refresh();
    });
    ref.listen(checkOutProvider, (_, next) {
      if (next is AsyncData && next.value is Success) refresh();
    });
    ref.listen(assignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.value is Success) refresh();
    });
    ref.listen(unassignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.hasValue) refresh();
    });
    ref.listen(makeSlotLeadProvider, (_, next) {
      if (next is AsyncData && next.hasValue) refresh();
    });
    return const AsyncValue.data(null);
  }

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
