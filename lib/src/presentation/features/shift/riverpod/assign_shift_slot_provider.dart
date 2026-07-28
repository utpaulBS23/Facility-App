import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';

part 'assign_shift_slot_provider.g.dart';

@riverpod
class AssignShiftSlot extends _$AssignShiftSlot {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> assign({
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
    required bool isSlotLead,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.shiftAssignAttendant)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(assignShiftSlotUseCaseProvider)
        .call(
          facilityId: facilityId,
          rosterId: rosterId,
          shiftSlotId: shiftSlotId,
          attendantId: attendantId,
          isSlotLead: isSlotLead,
        );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
