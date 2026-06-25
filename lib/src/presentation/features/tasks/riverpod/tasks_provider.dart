import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_entity.dart';

part 'tasks_provider.g.dart';

@riverpod
class Tasks extends _$Tasks {
  @override
  AsyncValue<List<TaskEntity>> build() => const AsyncValue.loading();

  Future<void> fetch({required String bucket}) async {
    state = const AsyncValue.loading();

    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) {
      state = AsyncValue.error('User not found', StackTrace.current);
      return;
    }

    final Result<List<TaskEntity>, String> result =
        await ref.read(getTasksUseCaseProvider).call(
          partnerId: partnerId,
          bucket: bucket,
        );

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('No data', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
