import 'delivery_complaint_status.dart';
import 'delivery_status.dart';
import 'supply_request_status.dart';

/// Filter query parameters for item catalog list.
class ItemCatalogFilter {
  const ItemCatalogFilter({
    required this.partnerId,
    this.search,
    this.category,
    this.isActive,
    this.page,
    this.pageSize,
  });

  final int partnerId;
  final String? search;
  final String? category;
  final bool? isActive;
  final int? page;
  final int? pageSize;
}

/// UI Tab filter option for supply request screens.
enum SupplyFilter {
  all,
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  inDelivery,
  delivered,
  rejected;

  bool matches(SupplyRequestStatus status) {
    return switch (this) {
      .all => true,
      .pendingSupervisor => status == .pendingSupervisor,
      .pendingOperationManager => status == .pendingOperationManager,
      .operationManagerApproved => status == .operationManagerApproved,
      .inDelivery => status == .inDelivery,
      .delivered => status == .delivered,
      .rejected => status == .rejected,
    };
  }

  SupplyRequestStatus? toRequestStatus() {
    return switch (this) {
      .all => null,
      .pendingSupervisor => .pendingSupervisor,
      .pendingOperationManager => .pendingOperationManager,
      .operationManagerApproved => .operationManagerApproved,
      .inDelivery => .inDelivery,
      .delivered => .delivered,
      .rejected => .rejected,
    };
  }
}

/// Filter query parameters for supply request list (`GET /supply-requests`).
class SupplyRequestQueryFilter {
  const SupplyRequestQueryFilter({
    required this.partnerId,
    this.facilityId,
    this.status,
    this.urgency,
    this.search,
    this.page,
    this.pageSize,
  });

  final int partnerId;
  final int? facilityId;
  final SupplyRequestStatus? status;
  final SupplyUrgency? urgency;
  final String? search;
  final int? page;
  final int? pageSize;
}

/// Filter query parameters for deliveries list (`GET /deliveries`).
class DeliveryFilter {
  const DeliveryFilter({
    required this.partnerId,
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int partnerId;
  final int? facilityId;
  final DeliveryStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;
}

/// Filter query parameters for delivery complaints list (`GET /deliveries/complaints`).
class DeliveryComplaintFilter {
  const DeliveryComplaintFilter({
    required this.partnerId,
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int partnerId;
  final int? facilityId;
  final DeliveryComplaintStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;
}

/// Filter query parameters for stock allocations list (`GET /stock-allocations`).
class StockAllocationFilter {
  const StockAllocationFilter({
    required this.partnerId,
    this.facilityId,
    this.search,
    this.page,
    this.pageSize,
  });

  final int partnerId;
  final int? facilityId;
  final String? search;
  final int? page;
  final int? pageSize;
}
