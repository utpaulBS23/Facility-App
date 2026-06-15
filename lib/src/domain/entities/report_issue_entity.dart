enum IssuePriority { high, medium, normal, low }

class ReportIssueRequestEntity {
  const ReportIssueRequestEntity({
    required this.visitId,
    required this.department,
    required this.specificProblem,
    required this.location,
    required this.priority,
    this.notes,
    this.photoPath,
    this.assignedTo,
  });

  final int visitId;
  final String department;
  final String specificProblem;
  final String location;
  final IssuePriority priority;
  final String? notes;
  final String? photoPath;
  final String? assignedTo;
}

class ReportIssueResponseEntity {
  const ReportIssueResponseEntity({required this.id, required this.message});

  final int id;
  final String message;
}
