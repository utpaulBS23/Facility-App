import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';

part 'leave_attendants_provider.g.dart';

@riverpod
class LeaveAttendants extends _$LeaveAttendants {
  @override
  AsyncValue<List<LeaveAttendantEntity>> build() {
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
        await ref.read(getLeaveAttendantsUseCaseProvider).call(partnerId);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data ?? const []),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Failed to load attendants', StackTrace.current),
    };
  }
}
