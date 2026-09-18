import 'incentive_fine_calc_entity.dart';
import 'incentive_fine_facility_entity.dart';

class IncentiveFineReportEntity {
  const IncentiveFineReportEntity({
    required this.achievementRate,
    required this.statusLabel,
    required this.target,
    required this.totalIncome,
    required this.facilities,
    required this.calc,
  });

  final double achievementRate;
  final String statusLabel;
  final double target;
  final double totalIncome;
  final List<IncentiveFineFacilityEntity> facilities;
  final IncentiveFineCalcEntity calc;
}
