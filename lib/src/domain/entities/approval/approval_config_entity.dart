enum ApprovalModule {
  leave('leave'),
  supplyRequest('supply_request');

  const ApprovalModule(this.wireValue);

  final String wireValue;
}

/// One row of the backend's approval configuration: a step of some
/// requester group's approval chain.
class ApprovalConfigEntity {
  const ApprovalConfigEntity({
    required this.approverRoleLabel,
    required this.isActive,
    this.approverPermission,
    this.partnerId,
  });

  final String approverRoleLabel;
  final bool isActive;

  /// e.g. `leave.approve_step_4`; the trailing number identifies the role
  /// across every chain, which is how groups are ordered.
  final String? approverPermission;

  /// Null for ROOT-scoped rows that apply to every partner.
  final int? partnerId;
}

/// An approver group a request can be waiting on. [role] is the value to send
/// as `waiting_for`; [label] is its display name.
class ApprovalGroupEntity {
  const ApprovalGroupEntity({required this.role, required this.label});

  final String role;
  final String label;
}
