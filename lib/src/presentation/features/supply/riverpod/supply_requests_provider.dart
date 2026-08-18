import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';

part 'supply_requests_provider.g.dart';

@riverpod
class SupplyRequests extends _$SupplyRequests {
  String _searchQuery = '';
  SupplyFilter _selectedFilter = SupplyFilter.all;

  @override
  Future<PaginatedListEntity<SupplyRequestEntity>> build() async {
    return fetch(search: _searchQuery, filter: _selectedFilter);
  }

  Future<PaginatedListEntity<SupplyRequestEntity>> fetch({
    String search = '',
    SupplyFilter filter = SupplyFilter.all,
  }) async {
    _searchQuery = search;
    _selectedFilter = filter;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getSupplyRequestsUseCaseProvider)
        .call(SupplyRequestQueryFilter(
          search: search.isEmpty ? null : search,
          status: filter.toRequestStatus(),
        ));

    final paginated = result.when(
      success: (data) => data ?? const PaginatedListEntity.empty(),
      error: (error) => throw Exception(error.message),
    );

    state = AsyncValue.data(paginated);
    return paginated;
  }

  void search(String query) {
    fetch(search: query, filter: _selectedFilter);
  }

  void filter(SupplyFilter filter) {
    fetch(search: _searchQuery, filter: filter);
  }
}
