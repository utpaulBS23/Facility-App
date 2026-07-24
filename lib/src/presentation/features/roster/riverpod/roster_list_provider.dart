import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'roster_list_provider.g.dart';

@riverpod
class RosterList extends _$RosterList {
  @override
  AsyncValue<RosterListEntity?> build() => const AsyncValue.data(null);

  Future<void> fetch({required int facilityId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final Result<RosterListEntity, String> result = await ref
        .read(getRostersUseCaseProvider)
        .call(facilityId: facilityId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
