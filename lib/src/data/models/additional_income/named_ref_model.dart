import 'package:dart_mappable/dart_mappable.dart';

part 'named_ref_model.mapper.dart';

/// Shared shape for the nested `facility` / `submitted_by` objects on an
/// additional income record — avoids near-identical classes.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class NamedRefModel with NamedRefModelMappable {
  const NamedRefModel({required this.id, required this.name, this.nameBn});

  final int id;
  final String name;
  @MappableField(key: 'name_bn')
  final String? nameBn;

  static const fromJson = NamedRefModelMapper.fromJson;
}
