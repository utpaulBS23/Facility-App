class AssignmentRequestEntity {
  const AssignmentRequestEntity({
    required this.attendantId,
    required this.shiftTemplateId,
    required this.shiftDates,
    this.notes,
  });

  final int attendantId;
  final int shiftTemplateId;
  final List<String> shiftDates;
  final String? notes;
}

class AssignmentResponseEntity {
  const AssignmentResponseEntity({
    required this.assigned,
    required this.skipped,
    required this.total,
  });

  final int assigned;
  final int skipped;
  final int total;
}
