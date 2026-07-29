import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';

const List<String> kSupplyRequestStatuses = [
  'pending_supervisor',
  'pending_operation_manager',
  'operation_manager_approved',
  'in_delivery',
  'delivered',
  'rejected',
];

String supplyStatusLabel(BuildContext context, String status) => switch (status) {
      'pending_supervisor' => context.locale.pendingSupervisor,
      'pending_operation_manager' => context.locale.pendingOperationManager,
      'operation_manager_approved' => context.locale.operationManagerApproved,
      'in_delivery' => context.locale.inDelivery,
      'delivered' => context.locale.delivered,
      'rejected' => context.locale.rejected,
      _ => status,
    };

List<String> supplyFilterLabels(BuildContext context) => [
      context.locale.all,
      ...kSupplyRequestStatuses.map((s) => supplyStatusLabel(context, s)),
    ];

String? supplyStatusCodeForFilter(BuildContext context, String filter) =>
    filter == context.locale.all
        ? null
        : kSupplyRequestStatuses
            .firstWhere((s) => supplyStatusLabel(context, s) == filter);
