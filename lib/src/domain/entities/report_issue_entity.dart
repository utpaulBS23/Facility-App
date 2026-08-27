enum IssuePriority { high, medium, normal, low }

class ReportIssueRequestEntity {
  const ReportIssueRequestEntity({
    required this.visitId,
    required this.categoryValue,
    required this.title,
    required this.priority,
    this.description,
    this.assignedTo,
    this.dueAt,
    this.photoPath,
  });

  final int visitId;
  final String categoryValue;
  final String title;
  final IssuePriority priority;
  final String? description;
  final int? assignedTo;
  final String? dueAt;
  final String? photoPath;
}

class ReportIssueResponseEntity {
  const ReportIssueResponseEntity({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
  });

  final int id;
  final String title;
  final String priority;
  final String status;
}
