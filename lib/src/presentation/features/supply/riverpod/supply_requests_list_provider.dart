import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/supply/supply_filters.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import 'supply_request_action_provider.dart';

part 'supply_requests_list_provider.g.dart';

@riverpod
class SupplyRequestsList extends _$SupplyRequestsList {
  SupplyFilter _selectedFilter = SupplyFilter.all;

  @override
  Future<PaginatedListEntity<SupplyRequestEntity>> build() async {
    ref.listen(supplyRequestActionProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });

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
      error: (error) => throw error,
    );

    state = AsyncValue.data(paginated);
    return paginated;
  }

  void filter(SupplyFilter filter) {
    fetch(filter: filter);
  }
}
