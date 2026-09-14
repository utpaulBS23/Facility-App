import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  String? _lastFetchedDate;
  int _currentPage = 1;
  bool _hasMorePages = true;

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
    _currentPage = 1;
    _hasMorePages = true;
    state = const AsyncValue.loading();

    final Result<VisitListEntity, Failure> result = await ref
        .read(getMyVisitsUseCaseProvider)
        .call(date: date, page: 1, perPage: 10);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error(Failure.emptyResponse('load visits'), StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> loadMore({required String date}) async {
    if (!_hasMorePages) return;
    if (state.isLoading) return;

    final currentData = state.valueOrNull;
    if (currentData == null) return;

    _currentPage++;

    final Result<VisitListEntity, Failure> result = await ref
        .read(getMyVisitsUseCaseProvider)
        .call(date: date, page: _currentPage, perPage: 10);

    state = result.when(
      success: (data) {
        if (data == null || data.visits.isEmpty) {
          _hasMorePages = false;
          return AsyncValue.data(currentData);
        }
        _hasMorePages = _currentPage < (data.stats?.thisWeekCount ?? 0) ~/ 10 + 1;
        return AsyncValue.data(
          VisitListEntity(
            stats: currentData.stats,
            visits: [...currentData.visits, ...data.visits],
          ),
        );
      },
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

@riverpod
Future<List<MasterDataItemEntity>> visitTaskTypeOptions(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(
        category: 'taskType',
        perPage: 100,
        includeInactive: true,
      );
  return switch (result) {
    Success(:final data) => data ?? [],
    _ => [],
  };
}
