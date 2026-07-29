import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_policy_entity.dart';

part 'leave_policies_provider.g.dart';

@riverpod
class LeavePolicies extends _$LeavePolicies {
  @override
  AsyncValue<List<LeavePolicyEntity>> build() {
    fetch();
    return const AsyncValue.loading();
  }

  Future<void> fetch() async {
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    final result =
        await ref.read(getLeavePoliciesUseCaseProvider).call(partnerId);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data ?? const []),
      Error(:final error) => AsyncValue.error(error.message, StackTrace.current),
      _ => AsyncValue.error('Failed to load leave policies', StackTrace.current),
    };
  }
}
