import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../core/extensions/ref_extensions.dart';
import 'apply_leave_provider.dart';
import 'leave_request_action_provider.dart';

part 'leave_approvals_provider.g.dart';

@riverpod
class LeaveApprovals extends _$LeaveApprovals {
  @override
  Future<List<LeaveRequestEntity>> build({LeaveStatus? status}) async {
    // WHY: re-fetch supervisor approval queue when a leave action (approve/reject) completes.
    ref.invalidateProviderOnSuccess(leaveRequestActionProvider);
    // WHY: re-fetch supervisor approval queue when a new leave request is submitted for review.
    ref.invalidateProviderOnSuccess(applyLeaveActionProvider);

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref.read(getLeaveApprovalsUseCaseProvider).call(
          partnerId,
          status: status,
        );

    return result.getOrThrow()?.items ?? const []; 
  
  }
}
