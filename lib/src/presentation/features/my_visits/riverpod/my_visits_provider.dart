import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  @override
  AsyncValue<VisitListEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required String date}) async {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final Result<VisitListEntity, String> result = await ref
        .read(getMyVisitsUseCaseProvider)
        .call(partnerId: partnerId, date: date);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('No data', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
