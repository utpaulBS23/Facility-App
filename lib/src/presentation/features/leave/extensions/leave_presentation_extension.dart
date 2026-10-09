import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
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
          context.locale.cancelled,
          context.color.text.secondary,
        ),
      LeaveStatus.unknown => (
          context.locale.notAvailable,
          context.color.text.secondary,
        ),
    };
  }
}

extension LeaveRequestStatusPresentation on LeaveRequestEntity {
  /// Status label and dot colour. While the request is pending, the server's
  /// own step text wins ("Waiting for Ops Manager approval"), so custom
  /// approval chains read right without a client-side mapping.
  (String label, Color dotColor) statusLabelAndDotColor(BuildContext context) {
    final (label, dotColor) = status.labelAndDotColor(context);
    final stepLabel = currentStepLabel?.trim();
    // WHY the status, not currentStep: a terminal request is meant to carry
    // no step, but a cancelled one has come back with its old step and label.
    if (!isPending || stepLabel == null || stepLabel.isEmpty) {
      return (label, dotColor);
    }

    return (stepLabel, dotColor);
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
