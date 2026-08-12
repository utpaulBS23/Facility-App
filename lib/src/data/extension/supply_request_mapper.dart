import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../domain/entities/supply/delivery_complaint_status.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/entities/supply/delivery_status.dart';
import '../../domain/entities/supply/stock_allocation_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_status.dart';
import '../models/supply/delivery_complaint_model.dart';
import '../models/supply/delivery_model.dart';
import '../models/supply/delivery_response_model.dart';
import '../models/supply/stock_allocation_model.dart';
import '../models/supply/stock_item_model.dart';
import '../models/supply/stock_item_response_model.dart';
import '../models/supply/supply_request_model.dart';
import '../models/supply/supply_response_model.dart';

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

extension StockItemModelMapper on StockItemModel {
  StockItemEntity toEntity() {
    return StockItemEntity(
      id: id,
      partnerId: partnerId,
      partnerName: partnerName,
      itemCode: itemCode,
      name: name,
      category: category,
      unit: unit,
      unitPrice: unitPrice,
      isActive: isActive,
    );
  }
}

extension StockItemListResponseModelMapper on StockItemListResponseModel {
  PaginatedListEntity<StockItemEntity> toEntity() {
    final items = data.map((m) => m.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<StockItemEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}

extension DeliveryItemModelMapper on DeliveryItemModel {
  DeliveryItemEntity toEntity() {
    return DeliveryItemEntity(
      id: id,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      qtyExpected: qtyExpected,
      qtyReceived: qtyReceived,
      isVerified: isVerified,
      hasShortage: hasShortage,
    );
  }
}

extension DeliveryModelMapper on DeliveryModel {
  DeliveryEntity toEntity() {
    return DeliveryEntity(
      id: id,
      supplyRequestId: supplyRequestId,
      requestCode: requestCode,
      facilityId: facilityId,
      facilityName: facilityName,
      receivedBy: receivedBy,
      receivedByName: receivedByName,
      receiptPhotoUrl: receiptPhotoUrl,
      deliveryNotes: deliveryNotes,
      status: DeliveryStatus.fromWireString(status),
      itemCount: itemCount,
      items: items.map((i) => i.toEntity()).toList(),
      confirmedAt: confirmedAt,
      createdAt: createdAt,
    );
  }
}

extension DeliveryResponseModelMapper on DeliveryResponseModel {
  DeliveryEntity toEntity() => data.toEntity();
}

extension DeliveryListResponseModelMapper on DeliveryListResponseModel {
  PaginatedListEntity<DeliveryEntity> toEntity() {
    final items = data.map((m) => m.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<DeliveryEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}

extension DeliveryComplaintModelMapper on DeliveryComplaintModel {
  DeliveryComplaintEntity toEntity() {
    return DeliveryComplaintEntity(
      id: id,
      deliveryId: deliveryId,
      requestCode: requestCode,
      facilityId: facilityId,
      facilityName: facilityName,
      deliveryItemId: deliveryItemId,
      itemCode: itemCode,
      itemName: itemName,
      expectedQty: expectedQty,
      currentQtyReceived: currentQtyReceived,
      raisedBy: raisedBy,
      raisedByName: raisedByName,
      reportedQtyReceived: reportedQtyReceived,
      reason: reason,
      evidencePhotoUrl: evidencePhotoUrl,
      status: DeliveryComplaintStatus.fromWireString(status),
      reviewedBySupervisor: reviewedBySupervisor,
      reviewedBySupervisorName: reviewedBySupervisorName,
      reviewedByOperationManager: reviewedByOperationManager,
      reviewedByOperationManagerName: reviewedByOperationManagerName,
      createdAt: createdAt,
      resolvedAt: resolvedAt,
    );
  }
}

extension DeliveryComplaintResponseModelMapper on DeliveryComplaintResponseModel {
  DeliveryComplaintEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException('Missing data payload in DeliveryComplaintResponseModel');
    }
    return payload.toEntity();
  }
}

extension DeliveryComplaintListResponseModelMapper
    on DeliveryComplaintListResponseModel {
  PaginatedListEntity<DeliveryComplaintEntity> toEntity() {
    final items = data.map((m) => m.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<DeliveryComplaintEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}

extension StockAllocationItemModelMapper on StockAllocationItemModel {
  StockAllocationItemEntity toEntity() {
    return StockAllocationItemEntity(
      id: id,
      stockItemId: stockItemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      qty: qty,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }
}

extension StockAllocationModelMapper on StockAllocationModel {
  StockAllocationEntity toEntity() {
    return StockAllocationEntity(
      id: id,
      allocationCode: allocationCode,
      facilityId: facilityId,
      facilityName: facilityName,
      allocatedBy: allocatedBy,
      allocatedByName: allocatedByName,
      sourceRequestId: sourceRequestId,
      sourceRequestCode: sourceRequestCode,
      notes: notes,
      items: items.map((i) => i.toEntity()).toList(),
      totalValue: totalValue,
      allocatedAt: DateTime.tryParse(allocatedAt) ?? DateTime.now(),
    );
  }
}

extension StockAllocationResponseModelMapper on StockAllocationResponseModel {
  StockAllocationEntity toEntity() => data.toEntity();
}

extension StockAllocationListResponseModelMapper
    on StockAllocationListResponseModel {
  PaginatedListEntity<StockAllocationEntity> toEntity() {
    final items = data.map((m) => m.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<StockAllocationEntity>(
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
