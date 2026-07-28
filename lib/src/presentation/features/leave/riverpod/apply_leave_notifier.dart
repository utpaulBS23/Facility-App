import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/repositories/leave_repository.dart';

import 'leave_balance_provider.dart';
import 'my_leaves_provider.dart';

part 'apply_leave_notifier.g.dart';

@riverpod
class ApplyLeaveAction extends _$ApplyLeaveAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<LeaveRequestEntity?> submit(RequestLeaveParams params) async {
    if (state.isLoading) return null;

    final hasPerm = ref
            .read(hasPermissionUseCaseProvider)
            .call(AppPermission.leaveRequest) ||
        ref
            .read(hasPermissionUseCaseProvider)
            .call(AppPermission.leaveFileOnBehalf);
    if (!hasPerm) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return null;
    }

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return null;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(requestLeaveUseCaseProvider)
        .call(partnerId, params);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Submission failed', StackTrace.current),
    };

    if (result is Success<LeaveRequestEntity, String>) {
      ref.invalidate(myLeavesProvider);
      ref.invalidate(leaveBalanceProvider);
      return result.data;
    }

    return null;
  }
}
