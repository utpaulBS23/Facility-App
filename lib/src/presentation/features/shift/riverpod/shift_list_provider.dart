import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/entities/user_role.dart';

part 'shift_list_provider.g.dart';

@riverpod
class ShiftList extends _$ShiftList {
  @override
  AsyncValue<List<ShiftEntity>> build() => const AsyncValue.data([]);

  Future<void> fetch({
    required int partnerId,
    required String date,
    required UserRole role,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = role == UserRole.supervisor
        ? await ref
              .read(getSupervisorShiftsUseCaseProvider)
              .call(partnerId: partnerId, date: date)
        : await ref
              .read(getMyShiftsUseCaseProvider)
              .call(partnerId: partnerId, date: date);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data ?? []),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
