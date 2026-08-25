import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';

part 'task_occurrence_submit_provider.g.dart';

/// Submits one occurrence. [TaskOccurrences] listens to this provider and
/// refetches the board whenever a submit lands — same reasoning as
/// [TaskOccurrenceChecklistAnswer]: the list stays the single source of
/// truth for occurrence state instead of being patched locally here.
@riverpod
class TaskOccurrenceSubmit extends _$TaskOccurrenceSubmit {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<Result<TaskOccurrenceEntity, Failure>> submit({
    required int taskOccurrenceId,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(submitTaskOccurrenceUseCaseProvider)
        .call(taskOccurrenceId: taskOccurrenceId);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
    return result;
  }
}
