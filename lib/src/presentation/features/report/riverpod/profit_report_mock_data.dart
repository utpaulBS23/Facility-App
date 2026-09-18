import '../../../../domain/entities/report/convenience_benefit_entity.dart';
import '../../../../domain/entities/report/incentive_breakdown_row_entity.dart';
import '../../../../domain/entities/report/incentive_rate_row_entity.dart';
import '../../../../domain/entities/report/incentive_tier_entity.dart';
import '../../../../domain/entities/report/profit_report_entity.dart';
import '../../../../domain/entities/report/profit_summary_entity.dart';

/// WHY hardcoded here, not behind a use case: no profit-report API exists
/// yet — this backs the Monthly/Quarterly tab UI only, until the backend
/// contract is ready. Annual UI ships separately once that design lands.
final ProfitReportEntity monthlyProfitReportMockData = ProfitReportEntity(
  summary: const ProfitSummaryEntity(
    periodLabel: 'Current period: February 2026',
    achievementPercent: 108,
    performanceLabel: 'EXCELLENT',
    target: 450000,
    totalIncome: 486000,
  ),
  incentiveCalculationSubtitle: 'Personal — Monthly',
  incentiveTiers: const [
    IncentiveTierEntity(
      title: '90% — 99% Achievement',
      subtitle: 'Set amount: ৳2,500',
      isActive: false,
    ),
    IncentiveTierEntity(
      title: '100% Achievement',
      subtitle: 'Set amount: ৳4,000',
      isActive: false,
    ),
    IncentiveTierEntity(
      title: '100%+ Achievement',
      subtitle: '৳4,000 + ৳300/Each Additional 1%',
      isActive: true,
      breakdown: [
        IncentiveBreakdownRowEntity(
          label: 'Base Incentive',
          valueText: '৳4,000',
        ),
        IncentiveBreakdownRowEntity(
          label: 'Every 1% bonus (8% × ৳300)',
          valueText: '+৳2,400',
        ),
        IncentiveBreakdownRowEntity(
          label: 'TOTAL INCENTIVE',
          valueText: '৳6,400',
          isTotal: true,
        ),
      ],
    ),
  ],
  totalIncentiveText: '৳6,400',
  convenienceBenefitCount: 5,
  incentiveRateSubtitle: 'Supervisor — Monthly',
  incentiveRateRows: const [
    IncentiveRateRowEntity(
      rangeLabel: '< 90%',
      valueText: '—',
      style: IncentiveRateRowStyle.muted,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '90% — 99%',
      valueText: '৳2,500',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%',
      valueText: '৳4,000',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%+',
      valueText: '+ ৳300/1%',
      style: IncentiveRateRowStyle.positive,
    ),
  ],
);

final ProfitReportEntity quarterlyProfitReportMockData = ProfitReportEntity(
  summary: const ProfitSummaryEntity(
    periodLabel: 'Current period: Jan — Mar 2026 (Q1)',
    achievementPercent: 95,
    performanceLabel: 'GOOD',
    target: 1350000,
    totalIncome: 1282500,
  ),
  incentiveCalculationSubtitle: 'Personal — Monthly',
  incentiveTiers: const [
    IncentiveTierEntity(
      title: '90% — 99% Achievement',
      subtitle: 'Set amount: ৳2,500',
      isActive: true,
      activeAmountText: '৳7,500',
    ),
    IncentiveTierEntity(
      title: '100% Achievement',
      subtitle: 'Set amount: ৳4,000',
      isActive: false,
    ),
    IncentiveTierEntity(
      title: '100%+ Achievement',
      subtitle: '৳12,000 + ৳900/each additional 1%',
      isActive: false,
    ),
  ],
  totalIncentiveText: '৳7,500',
  convenienceBenefitCount: 5,
  convenienceBenefits: const [
    ConvenienceBenefitEntity(
      facilityName: 'Mirpur-10 Public Toilet',
      achievedPercent: 104,
      target: 300000,
      achieved: 312000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Farmgate Overbridge Toilet',
      achievedPercent: 92,
      target: 270000,
      achieved: 248400,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Vijay Sarani Metro Station',
      achievedPercent: 105,
      target: 360000,
      achieved: 378000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Mirpur DOHS Central',
      achievedPercent: 92,
      target: 210000,
      achieved: 189000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Farmgate Bus Terminal',
      achievedPercent: 74,
      target: 210000,
      achieved: 155100,
    ),
  ],
  incentiveRateSubtitle: 'Supervisor — Monthly',
  incentiveRateRows: const [
    IncentiveRateRowEntity(
      rangeLabel: '< 90%',
      valueText: '—',
      style: IncentiveRateRowStyle.muted,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '90% — 99%',
      valueText: '৳2,500',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%',
      valueText: '৳4,000',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%+',
      valueText: '৳4,000',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '< 70%',
      valueText: 'Determined by management',
      style: IncentiveRateRowStyle.note,
    ),
  ],
);

final ProfitReportEntity annualProfitReportMockData = ProfitReportEntity(
  summary: const ProfitSummaryEntity(
    periodLabel: 'Current period: 2025',
    achievementPercent: 65,
    performanceLabel: 'EXCELLENT',
    target: 5400000,
    totalIncome: 3510000,
  ),
  incentiveCalculationSubtitle: 'Personal — Monthly',
  incentiveTiers: const [
    IncentiveTierEntity(
      title: '90% — 99% Achievement',
      subtitle: 'Amount set: ৳30,000',
      isActive: false,
    ),
    IncentiveTierEntity(
      title: '100% Achievement',
      subtitle: 'Amount set: ৳48,000',
      isActive: false,
    ),
    IncentiveTierEntity(
      title: '100%+ Achievement',
      subtitle: '৳48,000 + ৳3,600/each additional 1%',
      isActive: false,
    ),
  ],
  incentiveNotApplicableNote: 'Below 90% of target',
  fineAlertnessMessage:
      'Penalties may be imposed for achieving less than 70% of the '
      'target. The amount will be determined by upper management.',
  fineAlertnessAmountNote: 'Fine Amount: Determined by Management',
  totalIncentiveText: '৳0',
  convenienceBenefitCount: 5,
  convenienceBenefits: const [
    ConvenienceBenefitEntity(
      facilityName: 'Mirpur-10 Public Toilet',
      achievedPercent: 75,
      target: 1200000,
      achieved: 900000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Farmgate Overbridge Toilet',
      achievedPercent: 70,
      target: 1080000,
      achieved: 756000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Vijay Sarani Metro Station',
      achievedPercent: 65,
      target: 1440000,
      achieved: 936000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Mirpur DOHS Central',
      achievedPercent: 60,
      target: 840000,
      achieved: 504000,
    ),
    ConvenienceBenefitEntity(
      facilityName: 'Farmgate Bus Terminal',
      achievedPercent: 49,
      target: 840000,
      achieved: 414000,
    ),
  ],
  incentiveRateSubtitle: 'Supervisor — Monthly',
  incentiveRateRows: const [
    IncentiveRateRowEntity(
      rangeLabel: '< 90%',
      valueText: '—',
      style: IncentiveRateRowStyle.muted,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '90% — 99%',
      valueText: '৳2,500',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%',
      valueText: '৳4,000',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '100%',
      valueText: '৳4,000',
      style: IncentiveRateRowStyle.positive,
    ),
    IncentiveRateRowEntity(
      rangeLabel: '< 70%',
      valueText: 'Determined by management',
      style: IncentiveRateRowStyle.note,
    ),
  ],
);
