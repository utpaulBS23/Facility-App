import '../../core/base/base.dart';
import '../entities/task_occurrence_entity.dart';

abstract base class TaskOccurrenceRepository extends Repository {
  Future<Result<TaskOccurrenceListEntity, Failure>> getTaskOccurrences({
    required int partnerId,
    required int facilityId,
    String? date,
  });

  Future<Result<TaskOccurrenceEntity, Failure>> reassignTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
    required int assignedTo,
  });

  Future<Result<ChecklistItemAnswerEntity, Failure>>
  answerTaskOccurrenceChecklistItem({
    required int partnerId,
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  });

  Future<Result<TaskOccurrenceEntity, Failure>> submitTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
  });
}
