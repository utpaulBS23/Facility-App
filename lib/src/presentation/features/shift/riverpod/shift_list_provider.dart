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
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final session = ref.read(getUserSessionUseCaseProvider).call();
    final role = session?.role ?? UserRole.attendant;

    final Result<List<ShiftEntity>, String> result = role == UserRole.supervisor
        ? await ref
              .read(getSupervisorShiftsUseCaseProvider)
              .call(partnerId: partnerId, date: date)
        : await ref
              .read(getMyShiftsUseCaseProvider)
              .call(partnerId: partnerId, date: date);

    state = result.when(
      success: (data) => AsyncValue.data(data ?? []),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
