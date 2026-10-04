import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';
import 'assign_roster_shift_provider.dart';
import 'create_shift_provider.dart';
import 'make_roster_slot_lead_provider.dart';
import 'unassign_roster_shift_provider.dart';

part 'roster_shifts_provider.g.dart';

@riverpod
class RosterShifts extends _$RosterShifts {
  int? _facilityId;
  int? _rosterId;

  @override
  AsyncValue<RosterShiftsEntity?> build() {
    // WHY self-refresh here rather than each caller invalidating this
    // provider after the fact: every action below changes this roster's
    // shifts (assignments, lead, new shifts) — listening once in the data
    // provider itself means a new caller can't forget to wire it.
    ref.listen(createShiftProvider, (_, next) {
      if (next is AsyncData && next.value != null) refresh();
    });
    ref.listen(assignRosterShiftProvider, (_, next) {
      if (next is AsyncData && next.value is Success) refresh();
    });
    ref.listen(unassignRosterShiftProvider, (_, next) {
      if (next is AsyncData && next.hasValue) refresh();
    });
    ref.listen(makeRosterSlotLeadProvider, (_, next) {
      if (next is AsyncData && next.hasValue) refresh();
    });
    return const AsyncValue.data(null);
  }

  Future<void> fetch({required int facilityId, required int rosterId}) async {
    if (state.isLoading) return;

    _facilityId = facilityId;
    _rosterId = rosterId;
    state = const AsyncValue.loading();

    final Result<RosterShiftsEntity, Failure> result = await ref
        .read(getRosterShiftsUseCaseProvider)
        .call(facilityId: facilityId, rosterId: rosterId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  /// Re-fetches the currently-loaded roster. No-op if nothing has been
  /// fetched yet.
  void refresh() {
    final facilityId = _facilityId;
    final rosterId = _rosterId;
    if (facilityId == null || rosterId == null) return;
    fetch(facilityId: facilityId, rosterId: rosterId);
  }
}
