class IssueDetailEntity {
  const IssueDetailEntity({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.description,
    this.assignedTo,
    this.problemCategory,
    this.facilityName,
    this.dueDate,
    this.photoUrl,
  });

  final int id;
  final String title;
  final String priority;
  final String status;
  final String? description;
  final int? assignedTo;
  final String? problemCategory;
  final String? facilityName;
  final DateTime? dueDate;
  final String? photoUrl;
}