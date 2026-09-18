import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/report/profit_report_period.dart';

part 'profit_report_period_provider.g.dart';

@riverpod
class ProfitReportPeriodSelection extends _$ProfitReportPeriodSelection {
  @override
  ProfitReportPeriod build() => ProfitReportPeriod.monthly;

  void select(ProfitReportPeriod period) => state = period;
}
