import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/training/training_session_entity.dart';
import '../../repositories/training_repository.dart';
import '../partner_use_case.dart';

final class GetTrainingSessionDetailsUseCase extends PartnerUseCase {
  GetTrainingSessionDetailsUseCase({
    required this.trainingRepository,
    required super.authRepository,
  });

  final TrainingRepository trainingRepository;

  Future<Result<TrainingSessionEntity, Failure>> call(
    int trainingSessionId,
  ) async {
    final partnerId = getPartnerId();
    final result = await trainingRepository.getTrainingSessionDetails(
      partnerId: partnerId,
      trainingSessionId: trainingSessionId,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get training session details')),
    };
  }
}
