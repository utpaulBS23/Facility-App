import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/theme/theme.dart';

extension SupplyRequestStatusLocalization on SupplyRequestStatus {
  String localizedName(BuildContext context) {
    return switch (this) {
      SupplyRequestStatus.pendingSupervisor => context.locale.pendingSupervisor,
      SupplyRequestStatus.pendingOperationManager =>
        context.locale.pendingOperationManager,
      SupplyRequestStatus.operationManagerApproved =>
        context.locale.operationManagerApproved,
      SupplyRequestStatus.inDelivery => context.locale.inDelivery,
      SupplyRequestStatus.delivered => context.locale.delivered,
      SupplyRequestStatus.rejected => context.locale.rejected,
      SupplyRequestStatus.completed => context.locale.completed,
      SupplyRequestStatus.unknown => context.locale.notAvailable,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      SupplyRequestStatus.pendingSupervisor => context.color.warning,
      SupplyRequestStatus.pendingOperationManager => context.color.info,
      SupplyRequestStatus.operationManagerApproved => context.color.primary,
      SupplyRequestStatus.inDelivery => context.color.text.secondary,
      SupplyRequestStatus.delivered => context.color.success,
      SupplyRequestStatus.rejected => context.color.error,
      SupplyRequestStatus.completed => context.color.success,
      SupplyRequestStatus.unknown => context.color.text.secondary,
    };
  }
}

extension SupplyRequestStatusLabel on SupplyRequestEntity {
  /// Status text for display. While the request is pending, the server's own
  /// step text wins ("Waiting for Operation Manager approval"), so a custom
  /// chain reads right without a client-side mapping.
  String statusLabel(BuildContext context) {
    final stepLabel = currentStepLabel?.trim();
    // WHY the status, not currentStep: a terminal request may still carry its
    // old step and label.
    final isPending = status == SupplyRequestStatus.pendingSupervisor ||
        status == SupplyRequestStatus.pendingOperationManager;
    if (!isPending || stepLabel == null || stepLabel.isEmpty) {
      return status.localizedName(context);
    }

    return stepLabel;
  }
}

extension SupplyUrgencyLocalization on SupplyUrgency {
  String localizedName(BuildContext context) {
    return switch (this) {
      SupplyUrgency.urgent => context.locale.urgencyUrgent,
      SupplyUrgency.high => context.locale.urgencyHigh,
      SupplyUrgency.normal => context.locale.urgencyNormal,
      SupplyUrgency.low => context.locale.urgencyLow,
    };
  }

  Color urgencyColor(BuildContext context) {
    return switch (this) {
      SupplyUrgency.urgent => context.color.primary,
      SupplyUrgency.high => context.color.warning,
      SupplyUrgency.normal => context.color.success,
      SupplyUrgency.low => context.color.text.secondary,
    };
  }
}
