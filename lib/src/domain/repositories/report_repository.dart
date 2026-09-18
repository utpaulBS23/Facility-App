import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/report/incentive_fine_report_entity.dart';

abstract base class ReportRepository extends Repository {
  Future<Result<IncentiveFineReportEntity, Failure>> getIncentiveFineReport({
    required int partnerId,
    required int supervisorId,
    required String referenceMonth,
    required String periodType,
  });
}
