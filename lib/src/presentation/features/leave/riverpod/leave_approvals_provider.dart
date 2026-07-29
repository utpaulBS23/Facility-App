import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
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
      Success(:final data) => data?.items ?? const [],
      Error(:final error) => throw Exception(error.message),
      _ => throw Exception('Failed to load leave approvals'),
    };
  }
}
