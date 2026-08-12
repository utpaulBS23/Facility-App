import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import 'supply_request_status.dart';

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
      SupplyFilter.pendingSupervisor => 'Pending Supervisor',
      SupplyFilter.pendingOperationManager => 'Pending Ops Manager',
      SupplyFilter.operationManagerApproved => 'Approved',
      SupplyFilter.inDelivery => 'In Delivery',
      SupplyFilter.delivered => 'Delivered',
      SupplyFilter.rejected => 'Rejected',
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
