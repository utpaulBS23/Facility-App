import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'roster_shifts_provider.g.dart';

@riverpod
class RosterShifts extends _$RosterShifts {
  @override
  AsyncValue<RosterShiftsEntity?> build() => const AsyncValue.data(null);

  Future<void> fetch({required int facilityId, required int rosterId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<RosterShiftsEntity, String> result = await ref
        .read(getRosterShiftsUseCaseProvider)
        .call(facilityId: facilityId, rosterId: rosterId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
