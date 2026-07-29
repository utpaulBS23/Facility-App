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

const String kSupplyFilterAll = 'All';

const List<String> kSupplyFilterKeys = [
  kSupplyFilterAll,
  ...kSupplyRequestStatuses,
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

String supplyFilterLabel(BuildContext context, String filterKey) =>
    filterKey == kSupplyFilterAll
        ? context.locale.all
        : supplyStatusLabel(context, filterKey);

String? supplyStatusCodeForFilter(String filterKey) =>
    filterKey == kSupplyFilterAll ? null : filterKey;
