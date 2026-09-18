import 'convenience_benefit_entity.dart';
import 'incentive_rate_row_entity.dart';
import 'incentive_tier_entity.dart';
import 'profit_summary_entity.dart';

class ProfitReportEntity {
  const ProfitReportEntity({
    required this.summary,
    required this.incentiveCalculationSubtitle,
    required this.incentiveTiers,
    required this.totalIncentiveText,
    this.incentiveNotApplicableNote,
    this.fineAlertnessMessage,
    this.fineAlertnessAmountNote,
    required this.convenienceBenefitCount,
    this.convenienceBenefits = const [],
    required this.incentiveRateSubtitle,
    required this.incentiveRateRows,
  });

  final ProfitSummaryEntity summary;

  final String incentiveCalculationSubtitle;
  final List<IncentiveTierEntity> incentiveTiers;
  final String totalIncentiveText;

  /// Shown in place of an active-tier row when none of [incentiveTiers]
  /// applies (achievement below the lowest slab).
  final String? incentiveNotApplicableNote;

  /// Shown below the tiers when achievement is low enough to risk a
  /// penalty — null when not applicable.
  final String? fineAlertnessMessage;
  final String? fineAlertnessAmountNote;

  final int convenienceBenefitCount;

  /// Per-facility breakdown — empty until the design for this section
  /// lands for a given period.
  final List<ConvenienceBenefitEntity> convenienceBenefits;

  final String incentiveRateSubtitle;
  final List<IncentiveRateRowEntity> incentiveRateRows;
}
