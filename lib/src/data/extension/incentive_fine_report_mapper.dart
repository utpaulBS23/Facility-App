import '../../domain/entities/report/incentive_fine_calc_entity.dart';
import '../../domain/entities/report/incentive_fine_facility_entity.dart';
import '../../domain/entities/report/incentive_fine_report_entity.dart';
import '../models/report/incentive_fine_report_response_model.dart';

extension IncentiveFineReportResponseModelMapper
    on IncentiveFineReportResponseModel {
  IncentiveFineReportEntity toEntity() {
    return IncentiveFineReportEntity(
      achievementRate: achievementRate ?? 0,
      statusLabel: statusLabel ?? '',
      target: target ?? 0,
      totalIncome: totalIncome ?? 0,
      facilities: facilities.map((facility) => facility.toEntity()).toList(),
      calc: _calcToEntity(),
    );
  }

  IncentiveFineCalcEntity _calcToEntity() {
    final incentive = incentiveCalc;
    if (incentive != null) {
      return IncentiveFineCalcEntity(
        type: IncentiveFineCalcType.incentive,
        matchedBandLabel: incentive.matchedBandLabel ?? '',
        amount: incentive.amount ?? 0,
      );
    }

    final fine = fineCalc;
    if (fine != null) {
      return IncentiveFineCalcEntity(
        type: IncentiveFineCalcType.fine,
        matchedBandLabel: fine.matchedBandLabel ?? '',
        amount: fine.amount ?? 0,
      );
    }

    return const IncentiveFineCalcEntity(
      type: IncentiveFineCalcType.notApplicable,
      matchedBandLabel: '',
      amount: 0,
    );
  }
}

extension IncentiveFineFacilityModelMapper on IncentiveFineFacilityModel {
  IncentiveFineFacilityEntity toEntity() {
    return IncentiveFineFacilityEntity(
      facilityName: facilityName ?? '',
      achievementRate: achievementRate ?? 0,
      target: target ?? 0,
      income: income ?? 0,
    );
  }
}
