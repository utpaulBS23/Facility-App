import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/report/incentive_fine_report_entity.dart';
import '../../../../domain/entities/report/profit_report_period.dart';

part 'incentive_fine_report_provider.g.dart';

@riverpod
class IncentiveFineReport extends _$IncentiveFineReport {
  @override
  AsyncValue<IncentiveFineReportEntity> build() => const AsyncValue.loading();

  Future<void> fetch({
    required int supervisorId,
    required String referenceMonth,
    required ProfitReportPeriod periodType,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(getIncentiveFineReportUseCaseProvider)
        .call(
          supervisorId: supervisorId,
          referenceMonth: referenceMonth,
          periodType: periodType,
        );

    state = result.when(
      success: (data) => AsyncValue.data(data as IncentiveFineReportEntity),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
