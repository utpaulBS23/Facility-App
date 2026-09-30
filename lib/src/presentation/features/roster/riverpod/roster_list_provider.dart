import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';
import 'publish_roster_provider.dart';

part 'roster_list_provider.g.dart';

@riverpod
class RosterList extends _$RosterList {
  int? _facilityId;

  @override
  AsyncValue<RosterListEntity?> build() {
    // WHY self-refresh here rather than the caller invalidating this
    // provider after the fact: publishing a roster changes its status in
    // this list — listening once in the data provider itself means a new
    // caller can't forget to wire it.
    ref.listen(publishRosterProvider, (_, next) {
      if (next is AsyncData && next.value != null) refresh();
    });
    return const AsyncValue.data(null);
  }

  Future<void> fetch({required int facilityId}) async {
    if (state.isLoading) return;

    _facilityId = facilityId;
    state = const AsyncValue.loading();

    final Result<RosterListEntity, Failure> result = await ref
        .read(getRostersUseCaseProvider)
        .call(facilityId: facilityId);

    state = result.when(
      success: AsyncValue.data,
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  /// Re-fetches the currently-loaded facility. No-op if nothing has been
  /// fetched yet.
  void refresh() {
    final facilityId = _facilityId;
    if (facilityId == null) return;
    fetch(facilityId: facilityId);
  }
}
