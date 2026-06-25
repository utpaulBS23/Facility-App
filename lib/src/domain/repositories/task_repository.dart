import '../../core/base/base.dart';
import '../entities/task_entity.dart';

abstract base class TaskRepository extends Repository {
  Future<Result<List<TaskEntity>, Failure>> getTasks();

  Future<Result<TaskEntity, Failure>> getTaskDetail(int id);
}
