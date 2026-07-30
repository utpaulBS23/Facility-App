import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../core/extensions/ref_extensions.dart';
import 'apply_leave_provider.dart';
import 'leave_request_action_provider.dart';

part 'my_leaves_provider.g.dart';

@riverpod
class MyLeaves extends _$MyLeaves {
  @override
  Future<List<LeaveRequestEntity>> build({LeaveStatus? status}) async {
    // WHY: re-fetch user's leave requests when a new leave is submitted.
    ref.invalidateProviderOnSuccess(applyLeaveActionProvider);
    // WHY: re-fetch user's leave requests when a leave request is approved, rejected, or cancelled.
    ref.invalidateProviderOnSuccess(leaveRequestActionProvider);

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref.read(getMyLeavesUseCaseProvider).call(
          partnerId,
          status: status,
        );

    return result.getOrThrow()?.items ?? const[];
  }
}
