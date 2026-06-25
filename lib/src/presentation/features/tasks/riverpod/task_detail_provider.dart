import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_entity.dart';

part 'task_detail_provider.g.dart';

@riverpod
class TaskDetail extends _$TaskDetail {
  @override
  AsyncValue<TaskEntity> build() => const AsyncValue.loading();

  Future<void> fetch(int id) async {
    state = const AsyncValue.loading();

    final Result<TaskEntity, String> result =
        await ref.read(getTaskDetailUseCaseProvider).call(id: id);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('Task not found', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
