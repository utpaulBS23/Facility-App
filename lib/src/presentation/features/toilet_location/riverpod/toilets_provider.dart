import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/toilet_location/toilet_filter.dart';
import '../../../../domain/entities/toilet_location/toilet_list_page_entity.dart';

part 'toilets_provider.g.dart';

@riverpod
class Toilets extends _$Toilets {
  ToiletListFilter _selectedFilter = ToiletListFilter.all;

  @override
  Future<ToiletListPageEntity> build() async {
    return fetch(filter: _selectedFilter);
  }

  Future<ToiletListPageEntity> fetch({
    ToiletListFilter filter = ToiletListFilter.all,
  }) async {
    _selectedFilter = filter;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getToiletsUseCaseProvider)
        .call(ToiletListQueryFilter(status: filter.status));

    final page = result.when(
      success: (data) => data ?? const ToiletListPageEntity.empty(),
      error: (error) => throw error,
    );

    state = AsyncValue.data(page);
    return page;
  }

  void filter(ToiletListFilter filter) {
    fetch(filter: filter);
  }
}
