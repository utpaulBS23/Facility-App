import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import 'apply_leave_provider.dart';
import 'leave_request_action_provider.dart';

part 'my_leaves_provider.g.dart';

@riverpod
class MyLeaves extends _$MyLeaves {
  @override
  Future<List<LeaveRequestEntity>> build({LeaveStatus? status}) async {
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
        .read(getMyLeavesUseCaseProvider)
        .call(status: status);

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
