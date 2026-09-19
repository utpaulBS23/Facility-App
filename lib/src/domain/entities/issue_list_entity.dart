class IssueEntity {
  const IssueEntity({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.facilityName,
    this.assignedToName,
    this.dueDate,
    this.problemCategory,
    this.issueStatus,
    this.photoUrl,
  });

  final int id;
  final String title;
  final String priority;
  final String status;
  final String? facilityName;
  final String? assignedToName;
  final DateTime? dueDate;
  final String? problemCategory;
  final String? issueStatus;
  final String? photoUrl;
}