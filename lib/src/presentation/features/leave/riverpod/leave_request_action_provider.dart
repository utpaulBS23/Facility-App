import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';

part 'leave_request_action_provider.g.dart';

@riverpod
class LeaveRequestAction extends _$LeaveRequestAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> approve(int leaveRequestId) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result =
        await ref.read(approveLeaveUseCaseProvider).call(leaveRequestId);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> reject(int leaveRequestId, {String? reason}) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(rejectLeaveUseCaseProvider)
        .call(leaveRequestId, reason: reason);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> cancel(int leaveRequestId) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result =
        await ref.read(cancelLeaveUseCaseProvider).call(leaveRequestId);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
