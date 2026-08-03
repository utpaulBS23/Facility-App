import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_filter.dart';

extension LeaveFilterLocalization on LeaveFilter {
  String localizedName(BuildContext context) {
    return switch (this) {
      LeaveFilter.all => context.locale.all,
      LeaveFilter.pendingSupervisor => context.locale.pending,
      LeaveFilter.pendingManager => context.locale.managerApproval,
      LeaveFilter.approved => context.locale.approved,
      LeaveFilter.rejected => context.locale.rejected,
    };
  }
}
