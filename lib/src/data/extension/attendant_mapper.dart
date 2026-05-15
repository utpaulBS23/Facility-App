import '../../domain/entities/attendant_entity.dart';
import '../models/attendant_model.dart';

extension AttendantModelToEntity on AttendantModel {
  AttendantEntity toEntity() => AttendantEntity(
    id: id,
    name: name ?? '',
    email: email ?? '',
    phone: phoneNumber ?? '',
    assignment: assignment == null
        ? const AttendantAssignmentEntity(
            assignmentType: '',
            isPrimary: false,
            isActive: false,
            assignedAt: '',
          )
        : AttendantAssignmentEntity(
            assignmentType: assignment!.assignmentType ?? '',
            isPrimary: (assignment!.isPrimary ?? 0) == 1,
            isActive: (assignment!.isActive ?? 0) == 1,
            assignedAt: assignment!.assignedAt ?? '',
            assignedBy: assignment!.assignedBy,
          ),
  );
}
