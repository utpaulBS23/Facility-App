class AssignmentRequestEntity {
  const AssignmentRequestEntity({
    required this.attendantId,
    required this.shiftTemplateId,
    required this.shiftDate,
    this.notes,
  });

  final int attendantId;
  final int shiftTemplateId;
  final String shiftDate;
  final String? notes;
}

class AssignmentResponseEntity {
  const AssignmentResponseEntity({required this.id, required this.status});

  final int id;
  final String status;
}
