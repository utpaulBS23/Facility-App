import '../../core/base/base.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/task_entity.dart';

abstract base class TaskRepository extends Repository {
  Future<Result<PaginatedListEntity<TaskEntity>, Failure>> getIssues({
    required int partnerId,
    String? status,
    int? facilityId,
    int? page,
    int? perPage,
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

  Future<Result<TaskEntity, Failure>> updateIssueAssignment({
    required int partnerId,
    required int issueId,
    required int assignedTo,
  });
}
