import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/assignment_entity.dart';

part 'assignment_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class AssignmentRequestModel with AssignmentRequestModelMappable {
  AssignmentRequestModel({
    required this.attendantId,
    required this.shiftTemplateId,
    required this.shiftDates,
    this.notes,
  });

  @MappableField(key: 'attendant_id')
  final int attendantId;
  @MappableField(key: 'shift_template_id')
  final int shiftTemplateId;
  @MappableField(key: 'shift_dates')
  final List<String> shiftDates;
  final String? notes;

  factory AssignmentRequestModel.fromEntity(AssignmentRequestEntity entity) =>
      AssignmentRequestModel(
        attendantId: entity.attendantId,
        shiftTemplateId: entity.shiftTemplateId,
        shiftDates: entity.shiftDates,
        notes: entity.notes,
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AssignmentSummaryModel with AssignmentSummaryModelMappable {
  AssignmentSummaryModel({
    required this.total,
    required this.assigned,
    required this.skipped,
  });

  final int total;
  final int assigned;
  final int skipped;

  static const fromJson = AssignmentSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AssignmentResponseModel with AssignmentResponseModelMappable {
  AssignmentResponseModel({
    required this.success,
    required this.message,
    required this.summary,
  });

  final bool success;
  final String message;
  final AssignmentSummaryModel summary;

  static const fromJson = AssignmentResponseModelMapper.fromJson;

  AssignmentResponseEntity toEntity() => AssignmentResponseEntity(
        assigned: summary.assigned,
        skipped: summary.skipped,
        total: summary.total,
      );
}
