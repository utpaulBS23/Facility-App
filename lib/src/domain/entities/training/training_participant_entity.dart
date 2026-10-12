import 'training_completion_status.dart';

class TrainingParticipantEntity {
  const TrainingParticipantEntity({
    required this.id,
    required this.userId,
    required this.completionStatus,
  });

  final int id;
  final int userId;
  final TrainingCompletionStatus completionStatus;
}
