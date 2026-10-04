import '../../core/utils/localized_text.dart';

class IssueEntity {
  const IssueEntity({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.facilityName,
    this.facilityNameBn = '',
    this.titleBn = '',
    this.assignedToName,
    this.assignedToNameBn = '',
    this.dueDate,
    this.problemCategory,
    this.issueStatus,
    this.photoUrl,
  });

  final int id;
  final String title;
  final String titleBn;
  final String priority;
  final String status;
  final String? facilityName;
  final String facilityNameBn;
  final String? assignedToName;
  final String assignedToNameBn;
  final DateTime? dueDate;
  final String? problemCategory;
  final String? issueStatus;
  final String? photoUrl;

  String localizedTitle(String languageCode) =>
      localizedText(languageCode, title, titleBn);

  String? localizedFacilityName(String languageCode) =>
      localizedTextOrNull(languageCode, facilityName, facilityNameBn);

  String? localizedAssignedToName(String languageCode) =>
      localizedTextOrNull(languageCode, assignedToName, assignedToNameBn);
}
