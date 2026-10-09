import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/app_permission.dart';
import '../../entities/toilet_location/facility_wise_report_entity.dart';
import '../../repositories/toilet_location_repository.dart';
import '../partner_use_case.dart';

/// Loads one facility's monthly report.
final class GetFacilityWiseReportUseCase extends PartnerUseCase {
  GetFacilityWiseReportUseCase({
    required this.toiletLocationRepository,
    required super.authRepository,
  });

  final ToiletLocationRepository toiletLocationRepository;

  /// [month] is `YYYY-MM`. Only closed months carry data.
  Future<Result<FacilityWiseReportEntity, Failure>> call({
    required int facilityId,
    required String month,
  }) async {
    if (!authRepository.hasPermission(UserPermission.reportFacilityWiseView)) {
      return const Error(Failure.permissionDenied);
    }

    return toiletLocationRepository.getFacilityWiseReport(
      partnerId: getPartnerId(),
      facilityId: facilityId,
      month: month,
    );
  }
}
