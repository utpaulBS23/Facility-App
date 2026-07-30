import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';

part 'make_slot_lead_provider.g.dart';

/// WHY gated on `shift.assign_attendant`, not a dedicated permission: choosing
/// the lead is offered as part of assigning staff (see
/// [SlotLeadConfirmDialog]) — promoting an already-assigned attendant later is
/// the same authority applied at a different time, not a new capability.
@riverpod
class MakeSlotLead extends _$MakeSlotLead {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> makeLead({
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.shiftAssignAttendant)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(makeSlotLeadUseCaseProvider)
        .call(
          facilityId: facilityId,
          rosterId: rosterId,
          shiftSlotId: shiftSlotId,
          attendantId: attendantId,
        );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
