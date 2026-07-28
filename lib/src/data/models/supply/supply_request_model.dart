import 'package:dart_mappable/dart_mappable.dart';

part 'supply_request_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestItemModel with SupplyRequestItemModelMappable {
  const SupplyRequestItemModel({
    required this.id,
    this.stockItemId,
    this.itemCode,
    this.itemName,
    this.unit,
    this.qtyRequested,
    this.unitPrice,
    this.lineTotal,
  });

  final int id;
  @MappableField(key: 'stock_item_id')
  final int? stockItemId;
  @MappableField(key: 'item_code')
  final String? itemCode;
  @MappableField(key: 'item_name')
  final String? itemName;
  final String? unit;
  @MappableField(key: 'qty_requested')
  final double? qtyRequested;
  @MappableField(key: 'unit_price')
  final double? unitPrice;
  @MappableField(key: 'line_total')
  final double? lineTotal;

  static const fromJson = SupplyRequestItemModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestApprovalModel with SupplyRequestApprovalModelMappable {
  const SupplyRequestApprovalModel({
    required this.id,
    this.approverId,
    this.approverName,
    this.approverRole,
    this.action,
    this.notes,
    this.actedAt,
  });

  final int id;
  @MappableField(key: 'approver_id')
  final int? approverId;
  @MappableField(key: 'approver_name')
  final String? approverName;
  @MappableField(key: 'approver_role')
  final String? approverRole;
  final String? action;
  final String? notes;
  @MappableField(key: 'acted_at')
  final String? actedAt;

  static const fromJson = SupplyRequestApprovalModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SupplyRequestModel with SupplyRequestModelMappable {
  const SupplyRequestModel({
    required this.id,
    this.requestCode,
    this.facilityId,
    this.facilityName,
    this.requestedBy,
    this.requestedByName,
    this.initiatedByRole,
    this.urgency,
    this.notes,
    this.status,
    this.itemCount,
    this.totalValue,
    this.items,
    this.approvals,
    this.linkedAllocationId,
    this.allocationCode,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'request_code')
  final String? requestCode;
  @MappableField(key: 'facility_id')
  final int? facilityId;
  @MappableField(key: 'facility_name')
  final String? facilityName;
  @MappableField(key: 'requested_by')
  final int? requestedBy;
  @MappableField(key: 'requested_by_name')
  final String? requestedByName;
  @MappableField(key: 'initiated_by_role')
  final String? initiatedByRole;
  final String? urgency;
  final String? notes;
  final String? status;
  @MappableField(key: 'item_count')
  final int? itemCount;
  @MappableField(key: 'total_value')
  final double? totalValue;
  final List<SupplyRequestItemModel>? items;
  final List<SupplyRequestApprovalModel>? approvals;
  @MappableField(key: 'linked_allocation_id')
  final int? linkedAllocationId;
  @MappableField(key: 'allocation_code')
  final String? allocationCode;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = SupplyRequestModelMapper.fromJson;
}
