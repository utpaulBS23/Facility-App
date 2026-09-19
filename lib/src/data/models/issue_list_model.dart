import 'package:dart_mappable/dart_mappable.dart';

part 'issue_list_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class IssueItemModel with IssueItemModelMappable {
  IssueItemModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    this.facilityName,
    this.assignedToName,
    this.dueAt,
    this.problemCategory,
    this.issueStatus,
    this.media = const [],
  });

  final int id;
  final String title;
  final String priority;
  final String status;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;

  @MappableField(key: 'due_at')
  final String? dueAt;

  @MappableField(key: 'problem_category')
  final String? problemCategory;

  @MappableField(key: 'issue_status')
  final String? issueStatus;

  final List<IssueMediaModel>? media;

  static const fromJson = IssueItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class IssueMediaModel with IssueMediaModelMappable {
  IssueMediaModel({required this.id, this.url});

  final int id;
  final String? url;

  static const fromJson = IssueMediaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class IssueListResponseModel with IssueListResponseModelMappable {
  IssueListResponseModel({required this.data});

  final List<IssueItemModel> data;

  static const fromJson = IssueListResponseModelMapper.fromJson;
}