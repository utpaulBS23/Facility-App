import '../../core/base/base.dart';
import '../entities/task_entity.dart';

abstract base class TaskRepository extends Repository {
  Future<Result<List<TaskEntity>, Failure>> getTasks({
    required int partnerId,
    required String bucket,
    required String taskType,
  });

  Future<Result<TaskEntity, Failure>> getTaskDetail({
    required int partnerId,
    required int id,
  });
}
