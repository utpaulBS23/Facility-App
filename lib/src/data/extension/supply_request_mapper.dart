import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../domain/entities/supply/delivery_complaint_status.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/entities/supply/delivery_status.dart';
import '../../domain/entities/supply/stock_allocation_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_payloads.dart';
import '../../domain/entities/supply/supply_request_status.dart';
import '../../domain/entities/supply/supply_request_summary_entity.dart';
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
    );
  }
}

extension SupplyRequestApprovalModelMapper on SupplyRequestApprovalModel {
  SupplyRequestApprovalEntity toEntity() {
    return SupplyRequestApprovalEntity(
      id: id,
      approverName: approverName,
      approverRole: approverRole,
      action: action,
      notes: notes ?? '',
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
      requestedByName: requestedByName,
      initiatedByRole: initiatedByRole,
      urgency: SupplyUrgency.fromWireString(urgency),
      notes: notes ?? '',
      status: SupplyRequestStatus.fromWireString(status),
      itemCount: itemCount,
      items: items.map((i) => i.toEntity()).toList(),
      approvals: approvals.map((a) => a.toEntity()).toList(),
      allocationCode: allocationCode ?? '',
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

extension SupplyRequestSummaryModelMapper on SupplyRequestSummaryModel {
  SupplyRequestSummaryEntity toEntity() {
    return SupplyRequestSummaryEntity(
      pending: pending,
      approved: approved,
      rejected: rejected,
      completed: completed,
    );
  }
}

extension SupplyRequestSummaryResponseModelToEntity
    on SupplyRequestSummaryResponseModel {
  SupplyRequestSummaryEntity toEntity() {
    final payload = summary;
    if (payload == null) {
      throw const FormatException(
        'Missing summary payload in SupplyRequestSummaryResponseModel',
      );
    }
    return payload.toEntity();
  }
}

extension StockItemModelMapper on StockItemModel {
  StockItemEntity toEntity() {
    return StockItemEntity(
      id: id,
      itemCode: itemCode,
      name: name,
      category: category,
      unit: unit,
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
      receivedByName: receivedByName ?? '',
      receiptPhotoUrl: receiptPhotoUrl ?? '',
      deliveryNotes: deliveryNotes ?? '',
      status: DeliveryStatus.fromWireString(status),
      itemCount: itemCount,
      items: items.map((i) => i.toEntity()).toList(),
      confirmedAt: confirmedAt ?? '',
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
      raisedByName: raisedByName ?? '',
      reportedQtyReceived: reportedQtyReceived,
      reason: reason ?? '',
      evidencePhotoUrl: evidencePhotoUrl ?? '',
      status: DeliveryComplaintStatus.fromWireString(status),
      reviewedBySupervisorName: reviewedBySupervisorName ?? '',
      reviewedByOperationManagerName: reviewedByOperationManagerName ?? '',
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? '',
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
      allocatedByName: allocatedByName ?? '',
      sourceRequestCode: sourceRequestCode ?? '',
      notes: notes ?? '',
      items: items.map((i) => i.toEntity()).toList(),
      allocatedAt: allocatedAt,
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

extension CreateSupplyRequestEntityMapper on CreateSupplyRequestEntity {
  Map<String, dynamic> toBody() => {
    'facility_id': facilityId,
    if (urgency != null) 'urgency': urgency!.toWireString(),
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    'items': items.map((item) => {
      'stock_item_id': item.stockItemId,
      'qty_requested': item.qtyRequested,
      if (item.unitPrice != null) 'unit_price': item.unitPrice,
    }).toList(),
  };
}

extension ApproveSupplyRequestEntityMapper on ApproveSupplyRequestEntity {
  Map<String, dynamic> toBody() {
    final body = notes.toDecisionBody();
    final itemList = items;
    if (itemList != null && itemList.isNotEmpty) {
      body['items'] = itemList.map((item) => {
        'stock_item_id': item.stockItemId,
        'qty_requested': item.qtyRequested,
        if (item.unitPrice != null) 'unit_price': item.unitPrice,
      }).toList();
    }
    return body;
  }
}

extension ConfirmDeliveryRequestEntityMapper on ConfirmDeliveryRequestEntity {
  Map<String, dynamic> toBody() => {
    if (receiptPhotoUrl.isNotEmpty) 'receipt_photo_url': receiptPhotoUrl,
    if (deliveryNotes.isNotEmpty) 'delivery_notes': deliveryNotes,
    if (items.isNotEmpty)
      'items': items.map((item) => {
        'stock_item_id': item.stockItemId,
        'qty_received': item.qtyReceived,
        'is_verified': item.isVerified,
      }).toList(),
  };
}

extension FileDeliveryComplaintRequestEntityMapper
    on FileDeliveryComplaintRequestEntity {
  Map<String, dynamic> toBody() => {
    'delivery_item_id': deliveryItemId,
    'reported_qty_received': reportedQtyReceived,
    'reason': reason,
    if (evidencePhotoUrl.isNotEmpty) 'evidence_photo_url': evidencePhotoUrl,
  };
}

extension ApproveDeliveryComplaintRequestEntityMapper
    on ApproveDeliveryComplaintRequestEntity {
  Map<String, dynamic> toBody() => finalQtyReceived != null
      ? {'final_qty_received': finalQtyReceived}
      : const {};
}
