import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/report/incentive_fine_report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../extension/incentive_fine_report_mapper.dart';
import '../models/report/incentive_fine_report_response_model.dart';
import '../services/network/rest_client.dart';

final class ReportRepositoryImpl extends ReportRepository {
  ReportRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<IncentiveFineReportEntity, Failure>> getIncentiveFineReport({
    required int partnerId,
    required int supervisorId,
    required String referenceMonth,
    required String periodType,
  }) {
    return asyncGuard(() async {
      final response = await remote.getIncentiveFineReport(
        partnerId: partnerId,
        supervisorId: supervisorId,
        referenceMonth: referenceMonth,
        periodType: periodType,
      );
      final responseModel = IncentiveFineReportResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
