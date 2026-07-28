import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_balance_entity.dart';

part 'leave_balance_provider.g.dart';

@riverpod
class LeaveBalance extends _$LeaveBalance {
  @override
  Future<List<LeaveBalanceEntity>> build({int? attendantId}) async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return const [];

    final result = await ref.read(getLeaveBalancesUseCaseProvider).call(
          partnerId,
          attendantId: attendantId,
        );

    return switch (result) {
      Success(:final data) => data ?? const [],
      Error(:final error) => throw Exception(error.message),
      _ => throw Exception('Failed to load leave balances'),
    };
  }
}
