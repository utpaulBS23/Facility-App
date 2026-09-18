import 'package:dart_mappable/dart_mappable.dart';

import 'issue_list_model.dart';

part 'issue_detail_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class IssueDataModel with IssueDataModelMappable {
  IssueDataModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.description,
    this.assignedTo,
    this.assignedToName,
    this.problemCategory,
    this.facilityName,
    this.dueAt,
    this.issueStatus,
    this.resolvedAt,
    this.createdAt,
    this.media = const [],
  });

  final int id;
  final String title;
  final String priority;
  final String status;
  final String? description;

  @MappableField(key: 'assigned_to')
  final int? assignedTo;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  @MappableField(key: 'problem_category')
  final String? problemCategory;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'due_at')
  final String? dueAt;

  @MappableField(key: 'issue_status')
  final String? issueStatus;

  @MappableField(key: 'resolved_at')
  final String? resolvedAt;

  @MappableField(key: 'created_at')
  final String? createdAt;

  final List<IssueMediaModel>? media;

  static const fromJson = IssueDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class IssueDetailModel with IssueDetailModelMappable {
  IssueDetailModel({required this.data});

  final IssueDataModel data;

  static const fromJson = IssueDetailModelMapper.fromJson;
}