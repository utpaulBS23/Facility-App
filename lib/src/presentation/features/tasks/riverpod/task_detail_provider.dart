import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_entity.dart';

part 'task_detail_provider.g.dart';

@riverpod
class TaskDetail extends _$TaskDetail {
  @override
  AsyncValue<TaskEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required int taskId}) async {
    state = const AsyncValue.loading();

    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) {
      state = AsyncValue.error('User not found', StackTrace.current);
      return;
    }

    final Result<TaskEntity, String> result =
        await ref.read(getTaskDetailUseCaseProvider).call(
          partnerId: partnerId,
          id: taskId,
        );

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('Task not found', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
