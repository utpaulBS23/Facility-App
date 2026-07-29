import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/supply/supply_request_status.dart';

part 'supply_request_model.mapper.dart';

class SupplyRequestStatusHook extends MappingHook {
  const SupplyRequestStatusHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return SupplyRequestStatus.fromWireString(value);
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is SupplyRequestStatus) {
      return value.toWireString();
    }
    return value;
  }
}

class SupplyUrgencyHook extends MappingHook {
  const SupplyUrgencyHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return SupplyUrgency.fromWireString(value);
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is SupplyUrgency) {
      return value.toWireString();
    }
    return value;
  }
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestItemModel with SupplyRequestItemModelMappable {
  const SupplyRequestItemModel({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qtyRequested,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  @MappableField(key: 'stock_item_id')
  final int stockItemId;
  @MappableField(key: 'item_code')
  final String itemCode;
  @MappableField(key: 'item_name')
  final String itemName;
  final String unit;
  @MappableField(key: 'qty_requested')
  final double qtyRequested;
  @MappableField(key: 'unit_price')
  final double unitPrice;
  @MappableField(key: 'line_total')
  final double lineTotal;

  static const fromJson = SupplyRequestItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestApprovalModel with SupplyRequestApprovalModelMappable {
  const SupplyRequestApprovalModel({
    required this.id,
    required this.approverId,
    required this.approverName,
    required this.approverRole,
    required this.action,
    this.notes,
    required this.actedAt,
  });

  final int id;
  @MappableField(key: 'approver_id')
  final int approverId;
  @MappableField(key: 'approver_name')
  final String approverName;
  @MappableField(key: 'approver_role')
  final String approverRole;
  final String action;
  final String? notes;
  @MappableField(key: 'acted_at')
  final String actedAt;

  static const fromJson = SupplyRequestApprovalModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestModel with SupplyRequestModelMappable {
  const SupplyRequestModel({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.requestedBy,
    required this.requestedByName,
    required this.initiatedByRole,
    required this.urgency,
    this.notes,
    required this.status,
    required this.itemCount,
    required this.totalValue,
    this.items = const [],
    this.approvals = const [],
    this.linkedAllocationId,
    this.allocationCode,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'request_code')
  final String requestCode;
  @MappableField(key: 'facility_id')
  final int facilityId;
  @MappableField(key: 'facility_name')
  final String facilityName;
  @MappableField(key: 'requested_by')
  final int requestedBy;
  @MappableField(key: 'requested_by_name')
  final String requestedByName;
  @MappableField(key: 'initiated_by_role')
  final String initiatedByRole;
  @MappableField(hook: SupplyUrgencyHook())
  final SupplyUrgency urgency;
  final String? notes;
  @MappableField(hook: SupplyRequestStatusHook())
  final SupplyRequestStatus status;
  @MappableField(key: 'item_count')
  final int itemCount;
  @MappableField(key: 'total_value')
  final double totalValue;
  final List<SupplyRequestItemModel> items;
  final List<SupplyRequestApprovalModel> approvals;
  @MappableField(key: 'linked_allocation_id')
  final int? linkedAllocationId;
  @MappableField(key: 'allocation_code')
  final String? allocationCode;
  @MappableField(key: 'created_at')
  final String createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = SupplyRequestModelMapper.fromJson;
}
