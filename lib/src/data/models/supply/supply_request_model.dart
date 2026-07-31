import 'package:dart_mappable/dart_mappable.dart';

part 'supply_request_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qtyRequested;
  final double unitPrice;
  final double lineTotal;

  static const fromJson = SupplyRequestItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final int approverId;
  final String approverName;
  final String approverRole;
  final String action;
  final String? notes;
  final String actedAt;

  static const fromJson = SupplyRequestApprovalModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupplyRequestModel with SupplyRequestModelMappable {
  const SupplyRequestModel({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    required this.requestedBy,
    required this.requestedByName,
    required this.initiatedByRole,
    this.urgency,
    this.notes,
    this.status,
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
  final String requestCode;
  final int facilityId;
  final String facilityName;
  final int requestedBy;
  final String requestedByName;
  final String initiatedByRole;
  final String? urgency;
  final String? notes;
  final String? status;
  final int itemCount;
  final double totalValue;
  final List<SupplyRequestItemModel> items;
  final List<SupplyRequestApprovalModel> approvals;
  final int? linkedAllocationId;
  final String? allocationCode;
  final String createdAt;
  final String? updatedAt;

  static const fromJson = SupplyRequestModelMapper.fromJson;
}
