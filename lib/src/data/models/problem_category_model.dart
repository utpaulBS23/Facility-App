import 'package:dart_mappable/dart_mappable.dart';

part 'problem_category_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ProblemCategoryModel with ProblemCategoryModelMappable {
  ProblemCategoryModel({
    required this.value,
    this.label,
    this.color,
    this.isActive,
    this.proofRequiredOnComplete,
  });

  final String value;
  final String? label;
  final String? color;

  @MappableField(key: 'is_active')
  final bool? isActive;

  @MappableField(key: 'proof_required_on_complete')
  final bool? proofRequiredOnComplete;

  static const fromJson = ProblemCategoryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ProblemCategoryListModel with ProblemCategoryListModelMappable {
  ProblemCategoryListModel({this.data});

  final List<ProblemCategoryModel>? data;

  static const fromJson = ProblemCategoryListModelMapper.fromJson;
}
