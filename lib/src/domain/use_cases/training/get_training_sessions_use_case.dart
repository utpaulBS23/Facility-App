import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/training/training_filters.dart';
import '../../entities/training/training_session_entity.dart';
import '../../repositories/training_repository.dart';
import '../partner_use_case.dart';

final class GetTrainingSessionsUseCase extends PartnerUseCase {
  GetTrainingSessionsUseCase({
    required this.trainingRepository,
    required super.authRepository,
  });

  final TrainingRepository trainingRepository;

  Future<Result<PaginatedListEntity<TrainingSessionEntity>, Failure>> call([
    TrainingSessionQueryFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await trainingRepository.getTrainingSessions(
      (filter ?? const TrainingSessionQueryFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get training sessions')),
    };
  }
}
