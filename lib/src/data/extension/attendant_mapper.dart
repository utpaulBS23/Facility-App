import '../../domain/entities/attendant_entity.dart';
import '../models/attendant_model.dart';

extension AttendantModelToEntity on AttendantModel {
  AttendantEntity toEntity() => AttendantEntity(
    id: id,
    name: name,
    email: email,
    phone: phoneNumber,
    assignment: AttendantAssignmentEntity(
      assignmentType: assignment.assignmentType,
      isPrimary: assignment.isPrimary == 1,
      isActive: assignment.isActive == 1,
      assignedAt: assignment.assignedAt,
      assignedBy: assignment.assignedBy,
    ),
  );
}
