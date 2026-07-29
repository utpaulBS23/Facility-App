import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';

part 'my_leaves_provider.g.dart';

@riverpod
class MyLeaves extends _$MyLeaves {
  @override
  Future<List<LeaveRequestEntity>> build({LeaveStatus? status}) async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref.read(getMyLeavesUseCaseProvider).call(
          partnerId,
          status: status,
        );

    return switch (result) {
      Success(:final data) => data?.items ?? const [],
      Error(:final error) => throw Exception(error.message),
      _ => throw Exception('Failed to load my leaves'),
    };
  }
}
