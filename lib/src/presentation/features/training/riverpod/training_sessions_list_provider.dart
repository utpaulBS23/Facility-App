import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/training/training_filters.dart';
import '../../../../domain/entities/training/training_session_entity.dart';

part 'training_sessions_list_provider.g.dart';

@riverpod
class TrainingSessionsList extends _$TrainingSessionsList {
  TrainingFilter _selectedFilter = TrainingFilter.all;

  @override
  Future<PaginatedListEntity<TrainingSessionEntity>> build() async {
    return fetch(filter: _selectedFilter);
  }

  Future<PaginatedListEntity<TrainingSessionEntity>> fetch({
    TrainingFilter filter = TrainingFilter.all,
  }) async {
    _selectedFilter = filter;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getTrainingSessionsUseCaseProvider)
        .call(
          TrainingSessionQueryFilter(
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

  void filter(TrainingFilter filter) {
    fetch(filter: filter);
  }
}
