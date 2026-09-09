import 'package:dart_mappable/dart_mappable.dart';

part 'named_ref_model.mapper.dart';

/// Shared shape for the nested `facility` / `submitted_by` objects on an
/// additional income record — avoids near-identical classes.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NamedRefModel with NamedRefModelMappable {
  const NamedRefModel({required this.id, required this.name});

  final int id;
  final String name;

  static const fromJson = NamedRefModelMapper.fromJson;
}
