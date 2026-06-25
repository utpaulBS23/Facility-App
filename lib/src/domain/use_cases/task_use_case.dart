import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../core/base/result.dart';

final class GetTasksUseCase {
  GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<List<TaskEntity>, String>> call() async {
    final result = await _repository.getTasks();
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

  Future<Result<TaskEntity, String>> call({required int id}) async {
    final result = await _repository.getTaskDetail(id);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Task not found'),
    };
  }
}
