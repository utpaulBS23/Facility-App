import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';

part 'unassign_shift_slot_provider.g.dart';

@riverpod
class UnassignShiftSlot extends _$UnassignShiftSlot {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> unassign({
    required int facilityId,
    required int rosterId,
    required int shiftSlotId,
    required int attendantId,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.shiftUnassignAttendant)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(unassignShiftSlotUseCaseProvider)
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
