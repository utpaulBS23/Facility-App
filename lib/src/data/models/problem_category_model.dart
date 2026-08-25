import 'package:dart_mappable/dart_mappable.dart';

part 'problem_category_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ProblemCategoryModel with ProblemCategoryModelMappable {
  ProblemCategoryModel({
    required this.id,
    this.name,
    this.description,
    this.isActive,
  });

  final int id;
  final String? name;
  final String? description;

  @MappableField(key: 'is_active')
  final bool? isActive;

  static const fromJson = ProblemCategoryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ProblemCategoryListModel with ProblemCategoryListModelMappable {
  ProblemCategoryListModel({this.data});

  final List<ProblemCategoryModel>? data;

  static const fromJson = ProblemCategoryListModelMapper.fromJson;
}
