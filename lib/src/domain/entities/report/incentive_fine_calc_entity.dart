enum IncentiveFineCalcType { incentive, fine, notApplicable }

class IncentiveFineCalcEntity {
  const IncentiveFineCalcEntity({
    required this.type,
    required this.matchedBandLabel,
    required this.amount,
  });

  final IncentiveFineCalcType type;
  final String matchedBandLabel;
  final double amount;
}
