import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_balance_entity.dart';
import 'apply_leave_provider.dart';
import 'leave_request_action_provider.dart';

part 'leave_balance_provider.g.dart';

@riverpod
class LeaveBalance extends _$LeaveBalance {
  @override
  Future<List<LeaveBalanceEntity>> build({int? attendantId}) async {
    ref.listen(applyLeaveActionProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    ref.listen(leaveRequestActionProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    final result = await ref
        .read(getLeaveBalancesUseCaseProvider)
        .call(attendantId: attendantId);

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
