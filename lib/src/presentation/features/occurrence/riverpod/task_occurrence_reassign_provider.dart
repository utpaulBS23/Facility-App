import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';

part 'task_occurrence_reassign_provider.g.dart';

/// Reassigns one occurrence. [TaskOccurrences] listens to this provider and
/// refetches the board whenever a reassign lands — same reasoning as
/// [TaskOccurrenceChecklistAnswer]/[TaskOccurrenceSubmit]: the list stays
/// the single source of truth for occurrence state instead of being
/// patched locally here.
@riverpod
class TaskOccurrenceReassign extends _$TaskOccurrenceReassign {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<Result<TaskOccurrenceEntity, Failure>> reassign({
    required int taskOccurrenceId,
    required int assignedTo,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(reassignTaskOccurrenceUseCaseProvider)
        .call(taskOccurrenceId: taskOccurrenceId, assignedTo: assignedTo);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
    return result;
  }
}
