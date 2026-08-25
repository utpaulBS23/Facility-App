import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';

part 'task_occurrence_answer_provider.g.dart';

/// Answers one checklist item. [TaskOccurrences] listens to this provider
/// and refetches the board whenever an answer lands — the list stays the
/// single source of truth for checklist state instead of being patched
/// locally from here.
@riverpod
class TaskOccurrenceChecklistAnswer extends _$TaskOccurrenceChecklistAnswer {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<Result<ChecklistItemAnswerEntity, Failure>> answer({
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(answerTaskOccurrenceChecklistItemUseCaseProvider)
        .call(
          taskOccurrenceId: taskOccurrenceId,
          itemId: itemId,
          ratingValue: ratingValue,
          booleanValue: booleanValue,
          textValue: textValue,
          photoPath: photoPath,
          alt: alt,
        );

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
    return result;
  }
}
