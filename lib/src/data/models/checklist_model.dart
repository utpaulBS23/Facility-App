import 'package:dart_mappable/dart_mappable.dart';

part 'checklist_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemMediaModel with ChecklistItemMediaModelMappable {
  ChecklistItemMediaModel({required this.id, this.url});

  final int id;
  final String? url;

  static const fromJson = ChecklistItemMediaModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemResponseModel with ChecklistItemResponseModelMappable {
  ChecklistItemResponseModel({
    required this.id,
    this.ratingValue,
    this.booleanValue,
    this.hasProof,
    this.pointsAwarded,
    this.media,
  });

  final int id;

  @MappableField(key: 'rating_value')
  final int? ratingValue;

  @MappableField(key: 'boolean_value')
  final bool? booleanValue;

  @MappableField(key: 'has_proof')
  final bool? hasProof;

  @MappableField(key: 'points_awarded')
  final int? pointsAwarded;

  final List<ChecklistItemMediaModel>? media;

  static const fromJson = ChecklistItemResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ChecklistItemSaveResponseModel
    with ChecklistItemSaveResponseModelMappable {
  ChecklistItemSaveResponseModel({required this.data});

  final ChecklistItemResponseModel data;

  static const fromJson = ChecklistItemSaveResponseModelMapper.fromJson;
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
    required this.taskId,
    this.title,
    this.facilityName,
    this.assignedToName,
    this.priority,
    this.status,
  });

  @MappableField(key: 'task_id')
  final int taskId;
  final String? title;
  @MappableField(key: 'facility_name')
  final String? facilityName;
  @MappableField(key: 'assigned_to_name')
  final String? assignedToName;
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
  ChecklistModel({this.data, this.issues, this.meta});

  // API returns items in "data" key
  final List<ChecklistItemModel>? data;
  final List<ChecklistIssueModel>? issues;
  final ChecklistMetaModel? meta;

  static const fromJson = ChecklistModelMapper.fromJson;
}
