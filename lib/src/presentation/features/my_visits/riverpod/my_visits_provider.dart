import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  @override
  AsyncValue<VisitListEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required String date}) async {
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
}
