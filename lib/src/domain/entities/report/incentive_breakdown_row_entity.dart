class IncentiveBreakdownRowEntity {
  const IncentiveBreakdownRowEntity({
    required this.label,
    required this.valueText,
    this.isTotal = false,
  });

  final String label;
  final String valueText;
  final bool isTotal;
}
