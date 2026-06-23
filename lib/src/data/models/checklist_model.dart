import 'package:dart_mappable/dart_mappable.dart';

part 'checklist_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemResponseModel with ChecklistItemResponseModelMappable {
  ChecklistItemResponseModel({
    required this.id,
    this.ratingValue,
    this.booleanValue,
    this.hasProof,
  });

  final int id;

  @MappableField(key: 'rating_value')
  final int? ratingValue;

  @MappableField(key: 'boolean_value')
  final bool? booleanValue;

  @MappableField(key: 'has_proof')
  final bool? hasProof;

  static const fromJson = ChecklistItemResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemModel with ChecklistItemModelMappable {
  ChecklistItemModel({
    required this.id,
    this.label,
    this.responseType,
    this.maxPoints,
    this.proofPolicy,
    this.sortOrder,
    this.response,
  });

  final int id;
  final String? label;

  @MappableField(key: 'response_type')
  final String? responseType;

  @MappableField(key: 'max_points')
  final int? maxPoints;

  @MappableField(key: 'proof_policy')
  final String? proofPolicy;

  @MappableField(key: 'sort_order')
  final int? sortOrder;

  final ChecklistItemResponseModel? response;

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
    this.status,
  });

  final int id;
  final String? title;
  final String? category;
  final String? location;
  final String? priority;
  final String? status;

  static const fromJson = ChecklistIssueModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistMetaModel with ChecklistMetaModelMappable {
  ChecklistMetaModel({
    this.maxScore,
    this.itemsTotal,
    this.itemsCompleted,
    this.totalScore,
  });

  @MappableField(key: 'max_score')
  final int? maxScore;

  @MappableField(key: 'items_total')
  final int? itemsTotal;

  @MappableField(key: 'items_completed')
  final int? itemsCompleted;

  @MappableField(key: 'total_score')
  final int? totalScore;

  static const fromJson = ChecklistMetaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistModel with ChecklistModelMappable {
  ChecklistModel({
    this.data,
    this.issues,
    this.meta,
  });

  // API returns items in "data" key
  final List<ChecklistItemModel>? data;
  final List<ChecklistIssueModel>? issues;
  final ChecklistMetaModel? meta;

  static const fromJson = ChecklistModelMapper.fromJson;
}
