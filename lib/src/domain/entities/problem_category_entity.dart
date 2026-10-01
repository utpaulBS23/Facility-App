import '../../core/utils/localized_text.dart';

class ProblemCategoryEntity {
  const ProblemCategoryEntity({
    required this.value,
    required this.name,
    this.color,
    this.proofRequiredOnComplete = false,
    this.nameBn,
  });

  final String value;
  final String name;
  final String? nameBn;
  final String? color;
  final bool proofRequiredOnComplete;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
