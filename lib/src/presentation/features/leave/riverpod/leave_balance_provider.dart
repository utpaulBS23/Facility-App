import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_balance_entity.dart';

part 'leave_balance_provider.g.dart';

@riverpod
class LeaveBalance extends _$LeaveBalance {
  @override
  AsyncValue<List<LeaveBalanceEntity>> build({int? attendantId}) {
    fetch(attendantId: attendantId);
    return const AsyncValue.loading();
  }

  Future<void> fetch({int? attendantId}) async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(getLeaveBalancesUseCaseProvider).call(
          partnerId,
          attendantId: attendantId,
        );

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data ?? const []),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Failed to load leave balances', StackTrace.current),
    };
  }
}
