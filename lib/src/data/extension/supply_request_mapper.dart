import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_status.dart';
import '../models/supply/supply_request_model.dart';
import '../models/supply/supply_response_models.dart';

extension SupplyRequestItemModelMapper on SupplyRequestItemModel {
  SupplyRequestItemEntity toEntity() {
    return SupplyRequestItemEntity(
      id: id,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      qtyRequested: qtyRequested,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }
}

extension SupplyRequestApprovalModelMapper on SupplyRequestApprovalModel {
  SupplyRequestApprovalEntity toEntity() {
    return SupplyRequestApprovalEntity(
      id: id,
      approverId: approverId,
      approverName: approverName,
      approverRole: approverRole,
      action: action,
      notes: notes,
      actedAt: actedAt,
    );
  }
}

extension SupplyRequestModelMapper on SupplyRequestModel {
  SupplyRequestEntity toEntity() {
    return SupplyRequestEntity(
      id: id,
      requestCode: requestCode,
      facilityId: facilityId,
      facilityName: facilityName,
      requestedBy: requestedBy,
      requestedByName: requestedByName,
      initiatedByRole: initiatedByRole,
      urgency: SupplyUrgency.fromWireString(urgency),
      notes: notes,
      status: SupplyRequestStatus.fromWireString(status),
      itemCount: itemCount,
      totalValue: totalValue,
      items: items.map((i) => i.toEntity()).toList(),
      approvals: approvals.map((a) => a.toEntity()).toList(),
      linkedAllocationId: linkedAllocationId,
      allocationCode: allocationCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? createdAt,
    );
  }
}

extension SupplyRequestResponseModelToEntity on SupplyRequestResponseModel {
  SupplyRequestEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException(
        'Missing data payload in SupplyRequestResponse',
      );
    }

    return payload.toEntity();
  }
}

extension SupplyRequestListResponseModelToEntity on SupplyRequestListResponseModel {
  PaginatedListEntity<SupplyRequestEntity> toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<SupplyRequestEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}

extension SupplyDecisionNotesMapper on String? {
  Map<String, dynamic> toDecisionBody() {
    final notes = this;
    return notes != null && notes.isNotEmpty
        ? {'notes': notes}
        : <String, dynamic>{};
  }
}
