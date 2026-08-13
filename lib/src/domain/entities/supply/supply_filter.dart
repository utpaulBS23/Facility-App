
import 'supply_request_status.dart';

enum SupplyFilter {
  all,
  pendingSupervisor,
  pendingOperationManager,
  operationManagerApproved,
  inDelivery,
  delivered,
  rejected;

  

  bool matches(SupplyRequestStatus status) {
    return switch (this) {
      .all => true,
      .pendingSupervisor =>
        status == .pendingSupervisor,
      .pendingOperationManager =>
        status == .pendingOperationManager,
      .operationManagerApproved =>
        status == .operationManagerApproved,
      .inDelivery => status == .inDelivery,
      .delivered => status == .delivered,
      .rejected => status == .rejected,
    };
  }

  SupplyRequestStatus? toRequestStatus() {
    return switch (this) {
      .all => null,
      .pendingSupervisor => .pendingSupervisor,
      .pendingOperationManager =>
        .pendingOperationManager,
      .operationManagerApproved =>
        .operationManagerApproved,
      .inDelivery => .inDelivery,
      .delivered => .delivered,
      .rejected => .rejected,
    };
  }
}
