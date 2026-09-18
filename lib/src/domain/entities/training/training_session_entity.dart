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
  });

  final int id;
  final String title;
  final String description;
  final String facilityName;
  final String facilitatorName;
  final DateTime scheduledAt;
  final int durationMinutes;
  final TrainingStatus status;

  DateTime get endTime => scheduledAt.add(Duration(minutes: durationMinutes));
}
