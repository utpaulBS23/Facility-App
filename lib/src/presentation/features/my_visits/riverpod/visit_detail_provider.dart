import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'visit_detail_provider.g.dart';

@riverpod
class VisitDetail extends _$VisitDetail {
  @override
  AsyncValue<VisitDetailEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required int visitId}) async {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final Result<VisitDetailEntity, String> result = await ref
        .read(getVisitDetailUseCaseProvider)
        .call(partnerId: partnerId, visitId: visitId);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('Not found', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
