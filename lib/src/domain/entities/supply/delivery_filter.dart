import 'delivery_status.dart';

class DeliveryFilter {
  const DeliveryFilter({
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? facilityId;
  final DeliveryStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;
}
