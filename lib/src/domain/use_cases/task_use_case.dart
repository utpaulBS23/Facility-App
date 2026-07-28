import '../entities/task_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/task_repository.dart';
import '../../core/base/failure.dart';
import '../../core/base/result.dart';

final class GetTasksUseCase {
  GetTasksUseCase(this._repository, this._authRepository);

  final TaskRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<TaskEntity>, Failure>> call({
    required String bucket,
    String taskType = 'issue',
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getTasks(
      partnerId: partnerId,
      bucket: bucket,
      taskType: taskType,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load tasks')),
    };
  }
}

final class GetTaskDetailUseCase {
  GetTaskDetailUseCase(this._repository, this._authRepository);

  final TaskRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskEntity, Failure>> call({required int id}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getTaskDetail(
      partnerId: partnerId,
      id: id,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load the task')),
    };
  }
}

final class StartIssueUseCase {
  StartIssueUseCase(this._repository, this._authRepository);

  final TaskRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskEntity, Failure>> call({required int issueId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.startIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('start task')),
    };
  }
}

final class UploadTaskMediaUseCase {
  UploadTaskMediaUseCase(this._repository, this._authRepository);

  final TaskRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskMediaEntity, Failure>> call({
    required int taskId,
    required String photoPath,
    required String alt,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.uploadTaskMedia(
      partnerId: partnerId,
      taskId: taskId,
      photoPath: photoPath,
      alt: alt,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('upload task media')),
    };
  }
}

final class CompleteIssueUseCase {
  CompleteIssueUseCase(this._repository, this._authRepository);

  final TaskRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TaskEntity, Failure>> call({required int issueId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.completeIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('complete task')),
    };
  }
}
