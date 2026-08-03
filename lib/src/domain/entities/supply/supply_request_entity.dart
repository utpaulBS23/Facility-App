import '../common/paginated_list_entity.dart';
import 'supply_request_status.dart';

class SupplyRequestItemEntity {
  const SupplyRequestItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyRequested,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyRequested;
  final double unitPrice;
  final double lineTotal;
}

class SupplyRequestApprovalEntity {
  const SupplyRequestApprovalEntity({
    required this.id,
    required this.approverId,
    required this.approverName,
    required this.approverRole,
    required this.action,
    this.notes,
    required this.actedAt,
  });

  final int id;
  final int approverId;
  final String approverName;
  final String approverRole;
  final String action;
  final String? notes;
  final String actedAt;
}

class SupplyRequestEntity {
  const SupplyRequestEntity({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.requestedBy,
    required this.requestedByName,
    required this.initiatedByRole,
    required this.urgency,
    this.notes,
    required this.status,
    required this.itemCount,
    required this.totalValue,
    this.items = const [],
    this.approvals = const [],
    this.linkedAllocationId,
    this.allocationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int requestedBy;
  final String requestedByName;
  final String initiatedByRole;
  final SupplyUrgency urgency;
  final String? notes;
  final SupplyRequestStatus status;
  final int itemCount;
  final double totalValue;
  final List<SupplyRequestItemEntity> items;
  final List<SupplyRequestApprovalEntity> approvals;
  final int? linkedAllocationId;
  final String? allocationCode;
  final String createdAt;
  final String updatedAt;

  bool get isApprovedStage =>
      status == SupplyRequestStatus.operationManagerApproved ||
      status == SupplyRequestStatus.inDelivery ||
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  bool get isDelivered =>
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  bool get hasDelivery =>
      status == SupplyRequestStatus.inDelivery ||
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  bool get isPendingStage =>
      status == SupplyRequestStatus.pendingSupervisor ||
      status == SupplyRequestStatus.pendingOperationManager;
}

class SupplyRequestCounts {
  const SupplyRequestCounts({
    required this.pendingCount,
    required this.inDeliveryCount,
    required this.deliveredCount,
    required this.rejectedCount,
    required this.approvedCount,
  });

  final int pendingCount;
  final int inDeliveryCount;
  final int deliveredCount;
  final int rejectedCount;
  final int approvedCount;

  static SupplyRequestCounts getCount(PaginatedListEntity<SupplyRequestEntity>? response){
    return switch(response?.items){
      final items? => items.counts,
      null => const SupplyRequestCounts
      (pendingCount: 0, 
      inDeliveryCount: 0, 
      deliveredCount: 0, 
      rejectedCount: 0, 
      approvedCount: 0),
    };
  }
}

extension SupplyRequestListCounts on Iterable<SupplyRequestEntity> {
  SupplyRequestCounts get counts {
    int pending = 0;
    int inDelivery = 0;
    int delivered = 0;
    int rejected = 0;
    int approved = 0;

    for (final r in this) {
      switch (r.status) {
        case SupplyRequestStatus.pendingSupervisor:
        case SupplyRequestStatus.pendingOperationManager:
          pending++;
        case SupplyRequestStatus.inDelivery:
          inDelivery++;
        case SupplyRequestStatus.delivered:
          delivered++;
        case SupplyRequestStatus.completed:
          delivered++;
        case SupplyRequestStatus.rejected:
          rejected++;
        case SupplyRequestStatus.operationManagerApproved:
          approved++;
        case SupplyRequestStatus.unknown:
          break;
      }
    }

    return SupplyRequestCounts(
      pendingCount: pending,
      inDeliveryCount: inDelivery,
      deliveredCount: delivered,
      rejectedCount: rejected,
      approvedCount: approved,
    );
  }
}
