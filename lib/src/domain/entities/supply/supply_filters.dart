import 'delivery_complaint_status.dart';
import 'delivery_status.dart';
import 'supply_request_status.dart' show SupplyUrgency;

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

/// UI Tab filter option for supply request screens: the `status` and
/// `waiting_for` values to send.
///
/// WHY a class, not an enum: the "Pending · group" chips come from the
/// backend's approval configuration, so their number is not known at compile
/// time. Two filters are the same when they send the same query.
class SupplyFilter {
  const SupplyFilter._({this.status, this.waitingFor, this.label});

  /// Pending on one approver group; [role] is the `waiting_for` value and
  /// [label] its display name.
  const SupplyFilter.pendingFor({required String role, required String label})
    : this._(status: 'pending', waitingFor: role, label: label);

  /// Wire `status` to send; null for no status filter.
  final String? status;

  /// `approver_role` of the pending step; only valid with `status=pending`.
  final String? waitingFor;

  /// Display name of the group a [SupplyFilter.pendingFor] filter targets.
  final String? label;

  static const all = SupplyFilter._();

  /// Any pending status — also the fallback when the approver groups are
  /// unavailable.
  static const pending = SupplyFilter._(status: 'pending');
  static const operationManagerApproved = SupplyFilter._(
    status: 'operation_manager_approved',
  );
  static const inDelivery = SupplyFilter._(status: 'in_delivery');
  static const delivered = SupplyFilter._(status: 'delivered');
  static const rejected = SupplyFilter._(status: 'rejected');
  static const completed = SupplyFilter._(status: 'completed');

  /// The chips that never depend on the approver groups.
  static const terminal = [
    operationManagerApproved,
    inDelivery,
    delivered,
    rejected,
    completed,
  ];

  @override
  bool operator ==(Object other) =>
      other is SupplyFilter &&
      other.status == status &&
      other.waitingFor == waitingFor;

  @override
  int get hashCode => Object.hash(status, waitingFor);
}

/// Filter query parameters for supply request list (`GET /supply-requests`).
class SupplyRequestQueryFilter {
  const SupplyRequestQueryFilter({
    this.partnerId,
    this.facilityId,
    this.status,
    this.waitingFor,
    this.urgency,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final String? status;
  final String? waitingFor;
  final SupplyUrgency? urgency;
  final String? search;
  final int? page;
  final int? pageSize;

  SupplyRequestQueryFilter copyWith({
    int? partnerId,
    int? facilityId,
    String? status,
    String? waitingFor,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return SupplyRequestQueryFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      status: status ?? this.status,
      waitingFor: waitingFor ?? this.waitingFor,
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
