import '../../core/base/base.dart';
import '../entities/task_entity.dart';

abstract base class TaskRepository extends Repository {
  Future<Result<List<TaskEntity>, Failure>> getIssues({
    required int partnerId,
    String? status,
    int? facilityId,
  });

  Future<Result<TaskEntity, Failure>> getIssueDetail({
    required int partnerId,
    required int id,
  });

  Future<Result<TaskEntity, Failure>> startIssue({
    required int partnerId,
    required int issueId,
  });

  Future<Result<TaskEntity, Failure>> completeIssue({
    required int partnerId,
    required int issueId,
  });

  Future<Result<TaskMediaEntity, Failure>> uploadTaskMedia({
    required int partnerId,
    required int taskId,
    required String photoPath,
    required String alt,
  });
}
