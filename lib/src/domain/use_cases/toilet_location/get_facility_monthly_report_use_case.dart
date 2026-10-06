import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/app_permission.dart';
import '../../entities/toilet_location/facility_monthly_report_entity.dart';
import '../../repositories/toilet_location_repository.dart';
import '../partner_use_case.dart';
import 'build_facility_monthly_report.dart';

/// One facility's monthly report, added up from the day-to-day records.
final class GetFacilityMonthlyReportUseCase extends PartnerUseCase {
  GetFacilityMonthlyReportUseCase({
    required this.toiletLocationRepository,
    required super.authRepository,
  });

  final ToiletLocationRepository toiletLocationRepository;

  /// [month] is `YYYY-MM`.
  Future<Result<FacilityMonthlyReportEntity, Failure>> call({
    required int facilityId,
    required String month,
  }) async {
    if (!authRepository.hasPermission(UserPermission.reportFacilityWiseView)) {
      return const Error(Failure.permissionDenied);
    }

    final sources = await toiletLocationRepository.getFacilityReportSources(
      partnerId: getPartnerId(),
      month: month,
    );

    return switch (sources) {
      Success(:final data?) => Success(
        data: buildFacilityMonthlyReport(
          data,
          facilityId: facilityId,
          month: month,
        ),
      ),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('facility report sources')),
    };
  }
}
