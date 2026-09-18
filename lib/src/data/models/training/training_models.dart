import 'package:dart_mappable/dart_mappable.dart';

part 'training_models.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class TrainingSessionModel with TrainingSessionModelMappable {
  const TrainingSessionModel({
    required this.id,
    required this.title,
    this.description,
    this.facilityName,
    required this.facilitatorName,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
  });

  final int id;
  final String title;
  final String? description;
  final String? facilityName;
  final String facilitatorName;
  final String scheduledAt;
  final int durationMinutes;
  final String status;

  static const fromJson = TrainingSessionModelMapper.fromJson;
}
