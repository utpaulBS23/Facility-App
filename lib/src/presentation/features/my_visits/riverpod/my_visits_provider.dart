import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  @override
  AsyncValue<VisitListEntity> build() => const AsyncValue.data(
    VisitListEntity(
      stats: VisitStatsSummaryEntity(
        todayCount: 0,
        weekCount: 0,
        completedCount: 0,
      ),
      visits: [],
    ),
  );

  Future<void> fetch({required String date}) async {
    if (state.isLoading) return;

    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final Result<VisitListEntity, String> result = await ref
        .read(getMyVisitsUseCaseProvider)
        .call(partnerId: partnerId, date: date);

    state = result.when(
      success: (data) => AsyncValue.data(
        data ??
            const VisitListEntity(
              stats: VisitStatsSummaryEntity(
                todayCount: 0,
                weekCount: 0,
                completedCount: 0,
              ),
              visits: [],
            ),
      ),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
