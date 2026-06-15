import 'package:dart_mappable/dart_mappable.dart';

part 'report_issue_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ReportIssueResponseModel with ReportIssueResponseModelMappable {
  ReportIssueResponseModel({required this.id, this.message});

  final int id;
  final String? message;

  static const fromJson = ReportIssueResponseModelMapper.fromJson;
}
