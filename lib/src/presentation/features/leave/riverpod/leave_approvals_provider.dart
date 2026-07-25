import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';

part 'leave_approvals_provider.g.dart';

@riverpod
class LeaveApprovals extends _$LeaveApprovals {
  @override
  Future<List<LeaveRequestEntity>> build({String? status}) async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref.read(getLeaveApprovalsUseCaseProvider).call(
          partnerId,
          status: status,
        );

    return switch (result) {
      Success(:final data) => data ?? const [],
      Error(:final error) => throw Exception(error),
      _ => throw Exception('Failed to load leave approvals'),
    };
  }
}
