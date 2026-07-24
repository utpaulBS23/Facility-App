import '../../domain/entities/shift_template_entity.dart';
import '../models/shift_template_model.dart';

extension ShiftTemplateDataModelToEntity on ShiftTemplateDataModel {
  ShiftTemplateEntity toEntity() => ShiftTemplateEntity(
    id: id,
    name: name ?? '',
    startTime: startTime ?? '',
    endTime: endTime ?? '',
    durationHours: durationHours,
    isActive: isActive ?? true,
    notes: notes,
  );
}
