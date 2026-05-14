class AttendantAssignmentEntity {
  const AttendantAssignmentEntity({
    required this.assignmentType,
    required this.isPrimary,
    required this.isActive,
    required this.assignedAt,
    this.assignedBy,
  });

  final String assignmentType;
  final bool isPrimary;
  final bool isActive;
  final String assignedAt;
  final String? assignedBy;
}

class AttendantEntity {
  const AttendantEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.assignment,
  });

  final int id;
  final String name;
  final String email;
  final String phone;
  final AttendantAssignmentEntity assignment;
}
