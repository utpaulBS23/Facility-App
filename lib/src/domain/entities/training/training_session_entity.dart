import 'training_participant_entity.dart';
import 'training_status.dart';

class TrainingSessionEntity {
  const TrainingSessionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.facilityName,
    required this.facilitatorName,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    this.participants = const [],
  });

  final int id;
  final String title;
  final String description;
  final String facilityName;
  final String facilitatorName;
  final DateTime scheduledAt;
  final int durationMinutes;
  final TrainingStatus status;
  final List<TrainingParticipantEntity> participants;

  /// The participant record of [userId], if they are enrolled.
  TrainingParticipantEntity? participantFor(int? userId) {
    if (userId == null) return null;
    for (final participant in participants) {
      if (participant.userId == userId) return participant;
    }
    return null;
  }

  DateTime get endTime => scheduledAt.add(Duration(minutes: durationMinutes));
}
