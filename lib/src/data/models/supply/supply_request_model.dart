import 'package:dart_mappable/dart_mappable.dart';

import '../common/approval_step_model.dart';

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
    this.itemNameBn,
    required this.unit,
    required this.qtyRequested,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  @MappableField(key: 'item_name_bn')
  final String? itemNameBn;
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
class SupplyRequestModel with SupplyRequestModelMappable {
  const SupplyRequestModel({
    required this.id,
    required this.requestCode,
    required this.facilityId,
    required this.facilityName,
    this.facilityNameBn,
    required this.requestedBy,
    required this.requestedByName,
    this.requestedByNameBn,
    required this.initiatedByRole,
    this.urgency,
    this.notes,
    required this.status,
    required this.itemCount,
    required this.totalValue,
    this.items = const [],
    this.approvalSteps = const [],
    this.linkedAllocationId,
    this.allocationCode,
    required this.createdAt,
    this.updatedAt,
    this.currentStep,
    this.currentPermission,
    this.currentStepLabel,
    this.canAction,
  });

  final int id;
  final String requestCode;
  final int facilityId;
  final String facilityName;
  @MappableField(key: 'facility_name_bn')
  final String? facilityNameBn;
  final int requestedBy;
  final String requestedByName;
  @MappableField(key: 'requested_by_name_bn')
  final String? requestedByNameBn;
  final String initiatedByRole;
  final String? urgency;
  final String? notes;
  final String status;
  final int itemCount;
  final double totalValue;
  final List<SupplyRequestItemModel> items;
  final List<ApprovalStepModel> approvalSteps;
  final int? linkedAllocationId;
  final String? allocationCode;
  final String createdAt;
  final String? updatedAt;
  final int? currentStep;
  final String? currentPermission;
  final String? currentStepLabel;
  final bool? canAction;

  static const fromJson = SupplyRequestModelMapper.fromJson;
}
