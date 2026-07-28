import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'create_roster_provider.g.dart';

@riverpod
class CreateRoster extends _$CreateRoster {
  @override
  AsyncValue<RosterEntity?> build() => const AsyncValue.data(null);

  Future<void> create({
    required int facilityId,
    required String weekStartDate,
    required String weekEndDate,
    required List<int> offDays,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.rosterCreate)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(createRosterUseCaseProvider)
        .call(
          facilityId: facilityId,
          weekStartDate: weekStartDate,
          weekEndDate: weekEndDate,
          offDays: offDays,
        );

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }

  void reset() => state = const AsyncValue.data(null);
}
