import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';

enum SupplyFilter {
  all,
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  inDelivery,
  delivered,
  rejected;

  String localizedName(BuildContext context) {
    return switch (this) {
      SupplyFilter.all => context.locale.all,
      SupplyFilter.pendingSupervisor => context.locale.pendingSupervisor,
      SupplyFilter.pendingOperationManager =>
        context.locale.pendingOperationManager,
      SupplyFilter.operationManagerApproved =>
        context.locale.operationManagerApproved,
      SupplyFilter.inDelivery => context.locale.inDelivery,
      SupplyFilter.delivered => context.locale.delivered,
      SupplyFilter.rejected => context.locale.rejected,
    };
  }

  bool matches(SupplyRequestStatus status) {
    return switch (this) {
      SupplyFilter.all => true,
      SupplyFilter.pendingSupervisor =>
        status == SupplyRequestStatus.pendingSupervisor,
      SupplyFilter.pendingOperationManager =>
        status == SupplyRequestStatus.pendingOperationManager,
      SupplyFilter.operationManagerApproved =>
        status == SupplyRequestStatus.operationManagerApproved,
      SupplyFilter.inDelivery => status == SupplyRequestStatus.inDelivery,
      SupplyFilter.delivered => status == SupplyRequestStatus.delivered,
      SupplyFilter.rejected => status == SupplyRequestStatus.rejected,
    };
  }

  SupplyRequestStatus? toRequestStatus() {
    return switch (this) {
      SupplyFilter.all => null,
      SupplyFilter.pendingSupervisor => SupplyRequestStatus.pendingSupervisor,
      SupplyFilter.pendingOperationManager =>
        SupplyRequestStatus.pendingOperationManager,
      SupplyFilter.operationManagerApproved =>
        SupplyRequestStatus.operationManagerApproved,
      SupplyFilter.inDelivery => SupplyRequestStatus.inDelivery,
      SupplyFilter.delivered => SupplyRequestStatus.delivered,
      SupplyFilter.rejected => SupplyRequestStatus.rejected,
    };
  }
}
