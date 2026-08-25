enum ApproverRole {
  supervisor,
  operationManager;

  static ApproverRole fromWireString(String? raw) =>
      switch (raw?.toLowerCase()) {
        'supervisor' => ApproverRole.supervisor,
        'operation_manager' => ApproverRole.operationManager,
        _ => ApproverRole.supervisor,
      };
}

enum ApprovalAction {
  approved,
  rejected;

  static ApprovalAction fromWireString(String? raw) =>
      switch (raw?.toLowerCase()) {
        'approved' => ApprovalAction.approved,
        'rejected' => ApprovalAction.rejected,
        _ => ApprovalAction.approved,
      };
}
