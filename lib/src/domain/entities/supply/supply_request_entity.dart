import 'supply_request_status.dart';

class SupplyRequestItemEntity {
  const SupplyRequestItemEntity({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyRequested,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyRequested;
}

class SupplyRequestApprovalEntity {
  const SupplyRequestApprovalEntity({
    required this.id,
    required this.approverName,
    required this.approverRole,
    required this.action,
    required this.notes,
    required this.actedAt,
  });

  final int id;
  final String approverName;
  final String approverRole;
  final String action;
  final String notes;
  final String actedAt;
}

class SupplyRequestEntity {
  const SupplyRequestEntity({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.requestedByName,
    required this.initiatedByRole,
    required this.urgency,
    required this.notes,
    required this.status,
    required this.itemCount,
    this.items = const [],
    this.approvals = const [],
    required this.allocationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final String requestedByName;
  final String initiatedByRole;
  final SupplyUrgency urgency;
  final String notes;
  final SupplyRequestStatus status;
  final int itemCount;
  final List<SupplyRequestItemEntity> items;
  final List<SupplyRequestApprovalEntity> approvals;
  final String allocationCode;
  final String createdAt;
  final String updatedAt;

  /// True when the request has cleared both approval levels and is now either
  /// being dispatched, in transit, delivered, or fully completed.
  ///
  /// Used to gate UI sections that are only relevant after approval —
  /// e.g. showing delivery details or received-item confirmation.
  bool get isApprovedStage =>
      status == SupplyRequestStatus.operationManagerApproved ||
      status == SupplyRequestStatus.inDelivery ||
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  /// True when goods have physically arrived at the facility.
  ///
  /// Both [SupplyRequestStatus.delivered] and [SupplyRequestStatus.completed]
  /// represent a delivered state — `completed` means the delivery was also
  /// confirmed/closed by the receiving party.
  bool get isDelivered =>
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  /// True when a delivery record exists for this request, regardless of
  /// whether it has been fully confirmed yet.
  ///
  /// Covers the window from dispatch ([inDelivery]) through final closure
  /// ([completed]). Used to decide whether to show received-item cards
  /// and the delivery confirmation UI.
  bool get hasDelivery =>
      status == SupplyRequestStatus.inDelivery ||
      status == SupplyRequestStatus.delivered ||
      status == SupplyRequestStatus.completed;

  /// True when the request is waiting for a supervisor or operation manager
  /// to approve it.
  ///
  /// Both supervisor-level and operation-manager-level approvals are
  /// grouped here because the same "Approve / Reject" action bar is shown
  /// for both roles during this stage.
  bool get isPendingStage =>
      status == SupplyRequestStatus.pendingSupervisor ||
      status == SupplyRequestStatus.pendingOperationManager;

  /// True when the request has been approved by the operation manager but
  /// has not yet been dispatched (i.e. no delivery has been created).
  ///
  /// At this stage the dispatcher role can initiate a delivery ("Dispatch").
  bool get isDispatchStage =>
      status == SupplyRequestStatus.operationManagerApproved;

  /// Whether to show the bottom action bar for this request.
  ///
  /// The bar surfaces the primary action for the current stage:
  /// - [isPendingStage]  → Approve / Reject buttons
  /// - [isDispatchStage] → Dispatch button
  /// - [inDelivery]      → Confirm received quantities button
  bool get hasBottomActionBar =>
      isPendingStage ||
      isDispatchStage ||
      status == SupplyRequestStatus.inDelivery;
}
