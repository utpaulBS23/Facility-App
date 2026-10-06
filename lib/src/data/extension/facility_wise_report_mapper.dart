import '../../domain/entities/toilet_location/facility_wise_report_entity.dart';
import '../models/toilet_location/facility_wise_report_model.dart';

extension FacilityWiseRowModelToEntity on FacilityWiseRowModel {
  FacilityWiseRowEntity toEntity() => FacilityWiseRowEntity(
    facilityId: facilityId ?? 0,
    facilityName: facilityName ?? '',
    income: income ?? 0,
    accountsPaid: accountsPaid ?? 0,
    operationDepartment: operationDepartment ?? 0,
    expense: expense ?? 0,
    toBkash: toBkash ?? 0,
    toBank: toBank ?? 0,
    cashBalance: cashBalance ?? 0,
    profitLoss: profitLoss ?? 0,
  );
}

extension FacilityWiseReportResponseModelToEntity
    on FacilityWiseReportResponseModel {
  FacilityWiseReportEntity toEntity() => FacilityWiseReportEntity(
    facilities: [for (final f in facilities) f.toEntity()],
  );
}
