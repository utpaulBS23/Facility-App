import '../../core/base/base.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';
import '../services/network/rest_client.dart';

final class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<List<TaskEntity>, Failure>> getTasks({
    required int partnerId,
    required String bucket,
    required String taskType,
  }) => asyncGuard(() async {
    final response = await _client.getTasks(
      partnerId: partnerId,
      bucket: bucket,
      taskType: taskType,
    );
    final status = _bucketToStatus(bucket);
    return TaskListResponseModel.fromJson(response.data).toEntities(status);
  });

  @override
  Future<Result<TaskEntity, Failure>> getTaskDetail(int id) async =>
      const Error(Failure(type: FailureType.notFound, message: 'Not implemented'));

  static TaskStatus _bucketToStatus(String bucket) => switch (bucket) {
    'completed' => TaskStatus.completed,
    'pending' => TaskStatus.pending,
    _ => TaskStatus.today,
  };
}
