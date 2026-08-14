import 'delivery_complaint_status.dart';

class DeliveryComplaintFilter {
  const DeliveryComplaintFilter({
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? facilityId;
  final DeliveryComplaintStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;
}
