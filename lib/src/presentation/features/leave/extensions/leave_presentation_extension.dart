import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../../domain/entities/leave/leave_type.dart';
import '../../../core/theme/theme.dart';

/// Single source of truth for how a [LeaveStatus] renders in list/detail cards.
extension LeaveStatusPresentation on LeaveStatus {
  /// Localized status label paired with its [StatusDotTag] dot colour.
  (String label, Color dotColor) labelAndDotColor(BuildContext context) {
    return switch (this) {
      LeaveStatus.pendingSupervisor => (
          context.locale.pending,
          context.color.warning,
        ),
      LeaveStatus.pendingManager => (
          context.locale.managerApproval,
          context.color.info,
        ),
      LeaveStatus.pendingOwner => (
          context.locale.pendingOwner,
          context.color.info,
        ),
      LeaveStatus.approved => (
          context.locale.approved,
          context.color.success,
        ),
      LeaveStatus.rejected => (
          context.locale.rejected,
          context.color.error,
        ),
      LeaveStatus.cancelled => (
          context.locale.cancel,
          context.color.text.secondary,
        ),
      LeaveStatus.unknown => (
          context.locale.notAvailable,
          context.color.text.secondary,
        ),
    };
  }
}

/// Single source of truth for the localized label of a [LeaveType].
extension LeaveTypePresentation on LeaveType {
  String localizedLabel(BuildContext context) {
    return switch (this) {
      LeaveType.sickLeave => context.locale.sickLeave,
      LeaveType.casualLeave => context.locale.casualLeave,
      LeaveType.maternityLeave => context.locale.maternityLeave,
      LeaveType.annualLeave => context.locale.annualLeave,
      LeaveType.unpaidLeave => context.locale.unpaidLeave,
      LeaveType.other => context.locale.other,
    };
  }
}
