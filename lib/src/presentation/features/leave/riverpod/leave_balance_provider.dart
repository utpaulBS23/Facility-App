import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_balance_entity.dart';
import '../../../core/extensions/ref_extensions.dart';
import 'apply_leave_provider.dart';
import 'leave_request_action_provider.dart';

part 'leave_balance_provider.g.dart';

@riverpod
class LeaveBalance extends _$LeaveBalance {
  @override
  Future<List<LeaveBalanceEntity>> build({int? attendantId}) async {
    // WHY: re-fetch leave balance quota when a new leave is submitted.
    ref.invalidateProviderOnSuccess(applyLeaveActionProvider);
    // WHY: re-fetch leave balance quota when a leave is approved or cancelled.
    ref.invalidateProviderOnSuccess(leaveRequestActionProvider);

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref
        .read(getLeaveBalancesUseCaseProvider)
        .call(partnerId, attendantId: attendantId);

    return result.getOrThrow() ?? const[];
  }
}
