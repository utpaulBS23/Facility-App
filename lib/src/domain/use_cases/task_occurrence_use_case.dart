import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/task_occurrence_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/task_occurrence_repository.dart';

final class GetTaskOccurrencesUseCase {
  GetTaskOccurrencesUseCase(this._repository, this._authRepository);

  final TaskOccurrenceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskOccurrenceListEntity, Failure>> call({
    required int facilityId,
    String? date,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getTaskOccurrences(
      partnerId: partnerId,
      facilityId: facilityId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load task occurrences')),
    };
  }
}

final class ReassignTaskOccurrenceUseCase {
  ReassignTaskOccurrenceUseCase(this._repository, this._authRepository);

  final TaskOccurrenceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskOccurrenceEntity, Failure>> call({
    required int taskOccurrenceId,
    required int assignedTo,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.reassignTaskOccurrence(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
      assignedTo: assignedTo,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('reassign task occurrence')),
    };
  }
}

final class AnswerTaskOccurrenceChecklistItemUseCase {
  AnswerTaskOccurrenceChecklistItemUseCase(
    this._repository,
    this._authRepository,
  );

  final TaskOccurrenceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<ChecklistItemAnswerEntity, Failure>> call({
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.answerTaskOccurrenceChecklistItem(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
      itemId: itemId,
      ratingValue: ratingValue,
      booleanValue: booleanValue,
      textValue: textValue,
      photoPath: photoPath,
      alt: alt,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('answer checklist item')),
    };
  }
}

final class SubmitTaskOccurrenceUseCase {
  SubmitTaskOccurrenceUseCase(this._repository, this._authRepository);

  final TaskOccurrenceRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskOccurrenceEntity, Failure>> call({
    required int taskOccurrenceId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.submitTaskOccurrence(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit task occurrence')),
    };
  }
}
