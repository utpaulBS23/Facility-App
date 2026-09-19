class ToiletTargetEntity {
  const ToiletTargetEntity({
    required this.supervisorName,
    required this.targetRevenue,
    required this.actualRevenue,
    required this.hasActuals,
    required this.hasTarget,
    required this.targetProfit,
    required this.targetAttendancePct,
    required this.targetCompliancePct,
  });

  final String supervisorName;
  final double targetRevenue;

  /// Defaults to 0 in the mapper when the API sends `null` — no KPI engine
  /// populates it yet. [hasActuals] distinguishes that from a genuine 0.
  final double actualRevenue;
  final bool hasActuals;
  final double targetProfit;
  final double targetAttendancePct;
  final double targetCompliancePct;

  /// `false` when the API returns an empty `data` array — no target has
  /// been set for this toilet/month yet. Not an error state.
  final bool hasTarget;

  double get achievedPercent =>
      targetRevenue <= 0 ? 0 : (actualRevenue / targetRevenue * 100).clamp(0, 100);

  double get remainingAmount =>
      (targetRevenue - actualRevenue).clamp(0, double.infinity);
}
