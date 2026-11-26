enum ApprovalStepStatus {
  pending,
  approved,
  rejected,
  cancelled;

  static ApprovalStepStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'approved' => ApprovalStepStatus.approved,
      'rejected' => ApprovalStepStatus.rejected,
      'cancelled' || 'canceled' => ApprovalStepStatus.cancelled,
      _ => ApprovalStepStatus.pending,
    };
  }
}

class ApprovalStepApproverEntity {
  const ApprovalStepApproverEntity({required this.id, required this.name});

  final int id;
  final String name;
}

/// One step of a request's approval chain, shared by leave and supply
/// requests. [approverRole] is the raw snake_case slug (`hr_admin`) — the
/// set of approver groups is configured server-side, so it is never an enum.
class ApprovalStepEntity {
  const ApprovalStepEntity({
    required this.stepNumber,
    required this.approverRole,
    required this.status,
    this.requiredPermission,
    this.approver,
    this.decidedAt,
    this.note,
  });

  final int stepNumber;
  final String approverRole;
  final ApprovalStepStatus status;
  final String? requiredPermission;
  final ApprovalStepApproverEntity? approver;
  final String? decidedAt;
  final String? note;
}
