enum AttendanceApprovalStatus {
  pending,
  pendingCheckIn,
  approvedCheckIn,
  rejectedCheckIn,
  pendingCheckOut,
  approvedCheckOut,
  approved,
  rejected,
  absent,
  unknown;

  static AttendanceApprovalStatus fromWireString(String? raw) {
    return switch (raw) {
      'pending' => pending,
      'pending_check_in' => pendingCheckIn,
      'approved_check_in' => approvedCheckIn,
      'rejected_check_in' => rejectedCheckIn,
      'pending_check_out' => pendingCheckOut,
      'approved_check_out' => approvedCheckOut,
      'approved' || 'auto_approved' => approved,
      'rejected' => rejected,
      'absent' => absent,
      _ => unknown,
    };
  }

  bool get isPendingStage =>
      this == pending || this == pendingCheckIn || this == pendingCheckOut;

  // WHY: checkout is never rejectable per the backend workflow — only a
  // pending manual entry or a pending check-in can be rejected.
  bool get isRejectable => this == pending || this == pendingCheckIn;

  bool get isApprovedStage =>
      this == approved || this == approvedCheckIn || this == approvedCheckOut;
}
