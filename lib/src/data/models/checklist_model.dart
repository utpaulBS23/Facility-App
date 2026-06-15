import 'package:dart_mappable/dart_mappable.dart';

part 'checklist_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemModel with ChecklistItemModelMappable {
  ChecklistItemModel({
    required this.id,
    this.question,
    this.answerType,
    this.order,
  });

  final int id;
  final String? question;

  @MappableField(key: 'answer_type')
  final String? answerType;

  final int? order;

  static const fromJson = ChecklistItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistIssueModel with ChecklistIssueModelMappable {
  ChecklistIssueModel({
    required this.id,
    this.title,
    this.category,
    this.location,
    this.priority,
  });

  final int id;
  final String? title;
  final String? category;
  final String? location;
  final String? priority;

  static const fromJson = ChecklistIssueModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistModel with ChecklistModelMappable {
  ChecklistModel({
    this.maxScore,
    this.items,
    this.issues,
  });

  @MappableField(key: 'max_score')
  final int? maxScore;

  final List<ChecklistItemModel>? items;
  final List<ChecklistIssueModel>? issues;

  static const fromJson = ChecklistModelMapper.fromJson;
}
