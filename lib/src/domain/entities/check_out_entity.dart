class CheckOutEntity {
  CheckOutEntity({
    required this.isMatch,
    required this.similarity,
    required this.confidence,
    required this.validationStatus,
  });

  final bool isMatch;
  final double similarity;
  final double confidence;
  final String validationStatus;
}
