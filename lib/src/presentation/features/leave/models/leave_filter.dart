import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_status.dart';

enum LeaveFilter {
  all,
  pendingSupervisor,
  pendingManager,
  approved,
  rejected;

  String localizedName(BuildContext context) {
    return switch (this) {
      LeaveFilter.all => context.locale.all,
      LeaveFilter.pendingSupervisor => context.locale.pending,
      LeaveFilter.pendingManager => context.locale.managerApproval,
      LeaveFilter.approved => context.locale.approved,
      LeaveFilter.rejected => context.locale.rejected,
    };
  }

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
