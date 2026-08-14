import 'delivery_complaint_status.dart';
import 'delivery_status.dart';
import 'supply_request_status.dart';

/// Filter query parameters for item catalog list.
class ItemCatalogFilter {
  const ItemCatalogFilter({
    this.partnerId,
    this.search,
    this.category,
    this.isActive,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final String? search;
  final String? category;
  final bool? isActive;
  final int? page;
  final int? pageSize;

  ItemCatalogFilter copyWith({
    int? partnerId,
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? pageSize,
  }) {
    return ItemCatalogFilter(
      partnerId: partnerId ?? this.partnerId,
      search: search ?? this.search,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
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
    this.partnerId,
    this.facilityId,
    this.status,
    this.urgency,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final SupplyRequestStatus? status;
  final SupplyUrgency? urgency;
  final String? search;
  final int? page;
  final int? pageSize;

  SupplyRequestQueryFilter copyWith({
    int? partnerId,
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return SupplyRequestQueryFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Filter query parameters for deliveries list (`GET /deliveries`).
class DeliveryFilter {
  const DeliveryFilter({
    this.partnerId,
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final DeliveryStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;

  DeliveryFilter copyWith({
    int? partnerId,
    int? facilityId,
    DeliveryStatus? status,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return DeliveryFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      status: status ?? this.status,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Filter query parameters for delivery complaints list (`GET /deliveries/complaints`).
class DeliveryComplaintFilter {
  const DeliveryComplaintFilter({
    this.partnerId,
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final DeliveryComplaintStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;

  DeliveryComplaintFilter copyWith({
    int? partnerId,
    int? facilityId,
    DeliveryComplaintStatus? status,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return DeliveryComplaintFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      status: status ?? this.status,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Filter query parameters for stock allocations list (`GET /stock-allocations`).
class StockAllocationFilter {
  const StockAllocationFilter({
    this.partnerId,
    this.facilityId,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final String? search;
  final int? page;
  final int? pageSize;

  StockAllocationFilter copyWith({
    int? partnerId,
    int? facilityId,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return StockAllocationFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
