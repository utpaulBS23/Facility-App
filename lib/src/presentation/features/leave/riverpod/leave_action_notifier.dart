import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import 'leave_approvals_provider.dart';
import 'my_leaves_provider.dart';

part 'leave_action_notifier.g.dart';

@riverpod
class LeaveRequestAction extends _$LeaveRequestAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<bool> approve(int leaveRequestId) async {
    final hasPerm = ref.read(hasPermissionUseCaseProvider).call(AppPermission.leaveApproveSupervisor) ||
        ref.read(hasPermissionUseCaseProvider).call(AppPermission.leaveApproveManager);
    if (!hasPerm) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return false;
    }

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return false;

    state = const AsyncValue.loading();

    final result = await ref
        .read(approveLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId);

    return _handleResult(result);
  }

  Future<bool> reject(int leaveRequestId, {String? reason}) async {
    final hasPerm = ref.read(hasPermissionUseCaseProvider).call(AppPermission.leaveReject);
    if (!hasPerm) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return false;
    }

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return false;

    state = const AsyncValue.loading();

    final result = await ref
        .read(rejectLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId, reason: reason);

    return _handleResult(result);
  }

  Future<bool> cancel(int leaveRequestId) async {
    final hasPerm = ref.read(hasPermissionUseCaseProvider).call(AppPermission.leaveCancel);
    if (!hasPerm) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return false;
    }

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return false;

    state = const AsyncValue.loading();

    final result = await ref
        .read(cancelLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId);

    return _handleResult(result);
  }

  bool _handleResult(Result<LeaveRequestEntity, dynamic> result) {
    return switch (result) {
      Success(:final data) => () {
          state = AsyncValue.data(data);
          ref.invalidate(leaveApprovalsProvider);
          ref.invalidate(myLeavesProvider);
          return true;
        }(),
      Error(:final error) => () {
          state = AsyncValue.error(
            error.message ?? 'Operation failed',
            StackTrace.current,
          );
          return false;
        }(),
      _ => () {
          state = AsyncValue.error('Operation failed', StackTrace.current);
          return false;
        }(),
    };
  }
}
