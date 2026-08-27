import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  String? _lastFetchedDate;

  @override
  AsyncValue<VisitListEntity> build() {
    // WHY: cross-feature reactivity — inspection checklist submits a visit
    // through the same VisitRepository; its broadcast stream tells this list
    // to refetch instead of the checklist feature reaching into this one.
    final subscription = ref
        .read(watchVisitSubmittedUseCaseProvider)
        .call()
        .listen((_) => refresh());
    ref.onDispose(subscription.cancel);
    return const AsyncValue.loading();
  }

  Future<void> fetch({required String date}) async {
    _lastFetchedDate = date;
    state = const AsyncValue.loading();

    final Result<VisitListEntity, Failure> result = await ref
        .read(getMyVisitsUseCaseProvider)
        .call(date: date);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error(Failure.emptyResponse('load visits'), StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  // WHY: reuses the last requested date so callers (including the stream
  // listener above) don't need to know which date is currently selected.
  Future<void> refresh() async {
    final date = _lastFetchedDate;
    if (date == null) return;
    await fetch(date: date);
  }
}
