import '../../core/utils/localized_text.dart';

class IssueDetailEntity {
  const IssueDetailEntity({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.description,
    this.titleBn = '',
    this.descriptionBn = '',
    this.assignedTo,
    this.assignedToName,
    this.assignedToNameBn = '',
    this.problemCategory,
    this.facilityName,
    this.facilityNameBn = '',
    this.dueDate,
    this.resolvedDate,
    this.createdDate,
    this.photoUrl,
    this.media = const [],
  });

  final int id;
  final String title;
  final String titleBn;
  final String priority;
  final String status;
  final String? description;
  final String descriptionBn;
  final int? assignedTo;
  final String? assignedToName;
  final String assignedToNameBn;
  final String? problemCategory;
  final String? facilityName;
  final String facilityNameBn;
  final DateTime? dueDate;
  final DateTime? resolvedDate;
  final DateTime? createdDate;
  final String? photoUrl;
  final List<IssueMediaEntity> media;

  String localizedTitle(String languageCode) =>
      localizedText(languageCode, title, titleBn);

  String? localizedDescription(String languageCode) =>
      localizedTextOrNull(languageCode, description, descriptionBn);

  String? localizedAssignedToName(String languageCode) =>
      localizedTextOrNull(languageCode, assignedToName, assignedToNameBn);

  String? localizedFacilityName(String languageCode) =>
      localizedTextOrNull(languageCode, facilityName, facilityNameBn);
}

class IssueMediaEntity {
  const IssueMediaEntity({required this.id, required this.url});

  final int id;
  final String url;
}