class ProblemCategoryEntity {
  const ProblemCategoryEntity({
    required this.value,
    required this.name,
    this.color,
    this.proofRequiredOnComplete = false,
  });

  final String value;
  final String name;
  final String? color;
  final bool proofRequiredOnComplete;
}
