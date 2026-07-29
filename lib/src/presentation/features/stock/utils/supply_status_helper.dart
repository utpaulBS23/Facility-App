import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/theme/theme.dart';

const String kSupplyFilterAll = 'All';

final List<String> kSupplyFilterKeys = [
  kSupplyFilterAll,
  ...SupplyRequestStatus.values.map((s) => s.toWireString()),
];

String supplyStatusLabel(BuildContext context, SupplyRequestStatus status) =>
    switch (status) {
      SupplyRequestStatus.pendingSupervisor => context.locale.pendingSupervisor,
      SupplyRequestStatus.pendingOperationManager =>
        context.locale.pendingOperationManager,
      SupplyRequestStatus.operationManagerApproved =>
        context.locale.operationManagerApproved,
      SupplyRequestStatus.inDelivery => context.locale.inDelivery,
      SupplyRequestStatus.delivered => context.locale.delivered,
      SupplyRequestStatus.rejected => context.locale.rejected,
    };

String supplyFilterLabel(BuildContext context, String filterKey) =>
    filterKey == kSupplyFilterAll
        ? context.locale.all
        : supplyStatusLabel(
            context, SupplyRequestStatus.fromWireString(filterKey));

SupplyRequestStatus? supplyStatusCodeForFilter(String filterKey) =>
    filterKey == kSupplyFilterAll
        ? null
        : SupplyRequestStatus.fromWireString(filterKey);

String supplyUrgencyLabel(BuildContext context, SupplyUrgency urgency) =>
    switch (urgency) {
      SupplyUrgency.urgent => context.locale.urgencyUrgent,
      SupplyUrgency.high => context.locale.urgencyHigh,
      SupplyUrgency.normal => context.locale.urgencyNormal,
    };

Color supplyUrgencyColor(BuildContext context, SupplyUrgency urgency) =>
    switch (urgency) {
      SupplyUrgency.urgent => context.color.primary,
      SupplyUrgency.high => context.color.warning,
      SupplyUrgency.normal => context.color.success,
    };
