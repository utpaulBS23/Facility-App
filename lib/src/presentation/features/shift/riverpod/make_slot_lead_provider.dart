import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';

part 'make_slot_lead_provider.g.dart';

/// Backend confirms `shift.assign_attendant` gates this endpoint too —
/// promoting an already-assigned attendant is the same authority as choosing
/// the lead at assign time (see [SlotLeadConfirmDialog]), applied later.
@riverpod
class MakeSlotLead extends _$MakeSlotLead {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> makeLead({
    required int facilityId,
    required int rosterId,
    required int assignmentId,
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
          assignmentId: assignmentId,
        );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
