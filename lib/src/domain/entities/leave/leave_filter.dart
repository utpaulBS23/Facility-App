import 'leave_status.dart';

enum LeaveFilter {
  all,
  pendingSupervisor,
  pendingManager,
  approved,
  rejected;

  LeaveStatus? get status => switch (this) {
        LeaveFilter.all => null,
        LeaveFilter.pendingSupervisor => LeaveStatus.pendingSupervisor,
        LeaveFilter.pendingManager => LeaveStatus.pendingManager,
        LeaveFilter.approved => LeaveStatus.approved,
        LeaveFilter.rejected => LeaveStatus.rejected,
      };

  bool matches(LeaveStatus status) {
    return switch (this) {
      LeaveFilter.all => true,
      LeaveFilter.pendingSupervisor => status == LeaveStatus.pendingSupervisor,
      LeaveFilter.pendingManager => status == LeaveStatus.pendingManager,
      LeaveFilter.approved => status == LeaveStatus.approved,
      LeaveFilter.rejected => status == LeaveStatus.rejected,
    };
  }
}
