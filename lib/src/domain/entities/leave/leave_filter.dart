import 'leave_status.dart';

enum LeaveFilter {
  all,
  pendingSupervisor,
  pendingManager,
  approved,
  rejected;

  bool matches(LeaveStatus status) {
    return switch (this) {
      LeaveFilter.all => true,
      LeaveFilter.pendingSupervisor => status == LeaveStatus.pendingSupervisor,
      LeaveFilter.pendingManager => status == LeaveStatus.pendingManager,
      LeaveFilter.approved => status == LeaveStatus.approved,
      LeaveFilter.rejected => status == LeaveStatus.rejected,
    };
  }

  @override
  String toString() {
    return switch (this) {
      LeaveFilter.all => 'All',
      LeaveFilter.pendingSupervisor => 'Pending',
      LeaveFilter.pendingManager => 'Manager Approval',
      LeaveFilter.approved => 'Approved',
      LeaveFilter.rejected => 'Rejected',
    };
  }
}
