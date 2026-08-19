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

  /// Helper to find approval entry for a given role and action.
  SupplyRequestApprovalEntity? _approvalFor(String role, String action) {
    for (final approval in approvals) {
      if (approval.approverRole == role &&
          approval.action.toLowerCase() == action) {
        return approval;
      }
    }
    return null;
  }

  /// Helper to find the latest rejection approval entry.
  SupplyRequestApprovalEntity? get _lastRejection {
    for (final approval in approvals.reversed) {
      if (approval.action.toLowerCase() == 'rejected') {
        return approval;
      }
    }
    return null;
  }

  /// Returns the complete list of timeline step entities for UI rendering.
  ///
  /// Encapsulates the domain logic for calculating step completion,
  /// active stage, rejection state, and step timestamps based on status
  /// and recorded approval audit logs.
  List<SupplyTimelineStepEntity> get timelineSteps {
    final rejectedApproval =
        status == SupplyRequestStatus.rejected ? _lastRejection : null;
    final rejectedIndex = switch (rejectedApproval?.approverRole) {
      'supervisor' => 0,
      'operation_manager' => 1,
      _ => null,
    };

    final completedCount = switch (status) {
      SupplyRequestStatus.pendingSupervisor => 0,
      SupplyRequestStatus.pendingOperationManager => 1,
      SupplyRequestStatus.operationManagerApproved => 3,
      SupplyRequestStatus.inDelivery => 3,
      SupplyRequestStatus.delivered => 4,
      SupplyRequestStatus.rejected => 0,
      SupplyRequestStatus.completed => 4,
      SupplyRequestStatus.unknown => 0,
    };

    final activeIndex = switch (status) {
      SupplyRequestStatus.pendingSupervisor => 0,
      SupplyRequestStatus.pendingOperationManager => 1,
      SupplyRequestStatus.inDelivery => 3,
      _ => null,
    };

    final supervisorApproval = _approvalFor('supervisor', 'approved');
    final operationManagerApproval =
        _approvalFor('operation_manager', 'approved');

    final stepKinds = SupplyRequestStepKind.values;
    final dates = [
      supervisorApproval?.actedAt ??
          (rejectedIndex == 0 ? rejectedApproval?.actedAt : null) ??
          '',
      operationManagerApproval?.actedAt ??
          (rejectedIndex == 1 ? rejectedApproval?.actedAt : null) ??
          '',
      completedCount > 2 ? updatedAt : '',
      '',
    ];

    return List.generate(stepKinds.length, (i) {
      final isRejected = rejectedIndex == i;
      return SupplyTimelineStepEntity(
        kind: stepKinds[i],
        actedAt: dates[i],
        isCompleted: !isRejected && i < completedCount,
        isActive: !isRejected && activeIndex == i,
        isRejected: isRejected,
      );
    });
  }
}

enum SupplyRequestStepKind {
  supervisor,
  operationManager,
  approved,
  delivery,
}

class SupplyTimelineStepEntity {
  const SupplyTimelineStepEntity({
    required this.kind,
    required this.actedAt,
    required this.isCompleted,
    required this.isActive,
    required this.isRejected,
  });

  final SupplyRequestStepKind kind;
  final String actedAt;
  final bool isCompleted;
  final bool isActive;
  final bool isRejected;
}
