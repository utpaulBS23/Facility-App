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
    required int assignmentId,
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
          assignmentId: assignmentId,
        );

    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      // WHY: Result<void, Failure> only ever constructs as Success or Error,
      // but the analyzer can't prove that without a `sealed` declaration —
      // this branch is unreachable at runtime.
      _ => AsyncValue.error(
        const Failure(type: FailureType.unknown, message: 'Unreachable'),
        StackTrace.current,
      ),
    };
  }
}
