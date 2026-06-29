import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../core/base/result.dart';

final class GetTasksUseCase {
  GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<List<TaskEntity>, String>> call({
    required int partnerId,
    required String bucket,
    String taskType = 'issue',
  }) async {
    final result = await _repository.getTasks(
      partnerId: partnerId,
      bucket: bucket,
      taskType: taskType,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to load tasks'),
    };
  }
}

final class GetTaskDetailUseCase {
  GetTaskDetailUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<TaskEntity, String>> call({
    required int partnerId,
    required int id,
  }) async {
    final result = await _repository.getTaskDetail(
      partnerId: partnerId,
      id: id,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Task not found'),
    };
  }
}

final class StartIssueUseCase {
  StartIssueUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<TaskEntity, String>> call({
    required int partnerId,
    required int issueId,
  }) async {
    final result = await _repository.startIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to start task'),
    };
  }
}

final class UploadTaskMediaUseCase {
  UploadTaskMediaUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<TaskMediaEntity, String>> call({
    required int partnerId,
    required int taskId,
    required String photoPath,
    required String alt,
  }) async {
    final result = await _repository.uploadTaskMedia(
      partnerId: partnerId,
      taskId: taskId,
      photoPath: photoPath,
      alt: alt,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to upload task media'),
    };
  }
}

final class CompleteIssueUseCase {
  CompleteIssueUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<TaskEntity, String>> call({
    required int partnerId,
    required int issueId,
  }) async {
    final result = await _repository.completeIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to complete task'),
    };
  }
}
