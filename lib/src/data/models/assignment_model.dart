import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/assignment_entity.dart';

part 'assignment_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class AssignmentRequestModel with AssignmentRequestModelMappable {
  AssignmentRequestModel({
    required this.attendantId,
    required this.shiftTemplateId,
    required this.shiftDate,
    this.notes,
  });

  @MappableField(key: 'attendant_id')
  final int attendantId;
  @MappableField(key: 'shift_template_id')
  final int shiftTemplateId;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  final String? notes;

  factory AssignmentRequestModel.fromEntity(AssignmentRequestEntity entity) =>
      AssignmentRequestModel(
        attendantId: entity.attendantId,
        shiftTemplateId: entity.shiftTemplateId,
        shiftDate: entity.shiftDate,
        notes: entity.notes,
      );
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AssignmentDataModel with AssignmentDataModelMappable {
  AssignmentDataModel({required this.id, required this.shiftDate, required this.status});

  final int id;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  final String status;

  static const fromJson = AssignmentDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AssignmentResponseModel with AssignmentResponseModelMappable {
  AssignmentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AssignmentDataModel data;

  static const fromJson = AssignmentResponseModelMapper.fromJson;

  AssignmentResponseEntity toEntity() =>
      AssignmentResponseEntity(id: data.id, status: data.status);
}
