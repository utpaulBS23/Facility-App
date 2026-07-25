import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';

part 'leave_approvals_provider.g.dart';

@riverpod
class LeaveApprovals extends _$LeaveApprovals {
  @override
  AsyncValue<List<LeaveRequestEntity>> build({String? status}) {
    fetch(status: status);
    return const AsyncValue.loading();
  }

  Future<void> fetch({String? status}) async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(getLeaveApprovalsUseCaseProvider).call(
          partnerId,
          status: status,
        );

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data ?? const []),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Failed to load leave approvals', StackTrace.current),
    };
  }
}
