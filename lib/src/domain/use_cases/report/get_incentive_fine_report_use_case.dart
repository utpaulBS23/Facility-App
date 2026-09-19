import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/report/incentive_fine_report_entity.dart';
import '../../entities/report/profit_report_period.dart';
import '../../repositories/report_repository.dart';
import '../partner_use_case.dart';

final class GetIncentiveFineReportUseCase extends PartnerUseCase {
  GetIncentiveFineReportUseCase({
    required this.reportRepository,
    required super.authRepository,
  });

  final ReportRepository reportRepository;

  Future<Result<IncentiveFineReportEntity, Failure>> call({
    required int supervisorId,
    required String referenceMonth,
    required ProfitReportPeriod periodType,
  }) async {
    final partnerId = getPartnerId();
    final result = await reportRepository.getIncentiveFineReport(
      partnerId: partnerId,
      supervisorId: supervisorId,
      referenceMonth: referenceMonth,
      periodType: periodType.name,
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get incentive fine report')),
    };
  }
}
