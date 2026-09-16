import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/training/training_filters.dart';
import '../entities/training/training_session_entity.dart';

abstract base class TrainingRepository extends Repository {
  Future<Result<PaginatedListEntity<TrainingSessionEntity>, Failure>>
  getTrainingSessions(
    TrainingSessionQueryFilter filter,
  );

  Future<Result<TrainingSessionEntity, Failure>> getTrainingSessionDetails({
    required int partnerId,
    required int trainingSessionId,
  });
}
