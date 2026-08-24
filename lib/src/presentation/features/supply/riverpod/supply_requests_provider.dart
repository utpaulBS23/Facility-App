import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';

part 'supply_requests_provider.g.dart';

@riverpod
class SupplyRequests extends _$SupplyRequests {
  SupplyFilter _selectedFilter = SupplyFilter.all;

  @override
  Future<PaginatedListEntity<SupplyRequestEntity>> build() async {
    return fetch(filter: _selectedFilter);
  }

  Future<PaginatedListEntity<SupplyRequestEntity>> fetch({
    SupplyFilter filter = SupplyFilter.all,
  }) async {
    _selectedFilter = filter;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getSupplyRequestsUseCaseProvider)
        .call(
          SupplyRequestQueryFilter(
            status: filter.toRequestStatus(),
          ),
        );

    final paginated = result.when(
      success: (data) => data ?? const PaginatedListEntity.empty(),
      error: (error) => throw Exception(error.message),
    );

    state = AsyncValue.data(paginated);
    return paginated;
  }

  void filter(SupplyFilter filter) {
    fetch(filter: filter);
  }
}
