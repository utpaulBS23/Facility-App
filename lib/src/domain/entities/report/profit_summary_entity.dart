class ProfitSummaryEntity {
  const ProfitSummaryEntity({
    required this.periodLabel,
    required this.achievementPercent,
    required this.performanceLabel,
    required this.target,
    required this.totalIncome,
  });

  final String periodLabel;
  final double achievementPercent;
  final String performanceLabel;
  final double target;
  final double totalIncome;
}
