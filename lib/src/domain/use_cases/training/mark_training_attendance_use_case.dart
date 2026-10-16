import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/training/training_completion_status.dart';
import '../../entities/training/training_participant_entity.dart';
import '../../repositories/training_repository.dart';
import '../partner_use_case.dart';

final class MarkTrainingAttendanceUseCase extends PartnerUseCase {
  MarkTrainingAttendanceUseCase({
    required this.trainingRepository,
    required super.authRepository,
  });

  final TrainingRepository trainingRepository;

  Future<Result<TrainingParticipantEntity, Failure>> call({
    required int trainingSessionId,
    required int participantId,
    required TrainingCompletionStatus status,
  }) async {
    final partnerId = getPartnerId();
    final result = await trainingRepository.markTrainingAttendance(
      partnerId: partnerId,
      trainingSessionId: trainingSessionId,
      participantId: participantId,
      status: status,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('mark training attendance')),
    };
  }
}
