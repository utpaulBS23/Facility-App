import '../../core/base/exceptions.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../models/supply/supply_request_model.dart';
import '../models/supply/supply_response_models.dart';

extension SupplyRequestItemModelMapper on SupplyRequestItemModel {
  SupplyRequestItemEntity toEntity() => SupplyRequestItemEntity(
        id: id,
        stockItemId: stockItemId ?? 0,
        itemCode: itemCode ?? '',
        itemName: itemName ?? '',
        unit: unit ?? '',
        qtyRequested: qtyRequested ?? 0.0,
        unitPrice: unitPrice ?? 0.0,
        lineTotal: lineTotal ?? 0.0,
      );
}

extension SupplyRequestApprovalModelMapper on SupplyRequestApprovalModel {
  SupplyRequestApprovalEntity toEntity() => SupplyRequestApprovalEntity(
        id: id,
        approverId: approverId ?? 0,
        approverName: approverName ?? '',
        approverRole: approverRole ?? '',
        action: action ?? '',
        notes: notes,
        actedAt: actedAt ?? '',
      );
}

extension SupplyRequestModelMapper on SupplyRequestModel {
  SupplyRequestEntity toEntity() => SupplyRequestEntity(
        id: id,
        requestCode: requestCode ?? '',
        facilityId: facilityId ?? 0,
        facilityName: facilityName ?? '',
        requestedBy: requestedBy ?? 0,
        requestedByName: requestedByName ?? '',
        initiatedByRole: initiatedByRole ?? '',
        urgency: urgency ?? 'normal',
        notes: notes,
        status: status ?? 'pending_supervisor',
        itemCount: itemCount ?? 0,
        totalValue: totalValue ?? 0.0,
        items: items?.map((i) => i.toEntity()).toList() ?? const [],
        approvals: approvals?.map((a) => a.toEntity()).toList() ?? const [],
        linkedAllocationId: linkedAllocationId,
        allocationCode: allocationCode,
        createdAt: createdAt ?? '',
        updatedAt: updatedAt ?? '',
      );
}

extension SupplyRequestResponseModelToEntity on SupplyRequestResponseModel {
  SupplyRequestEntity toEntity() {
    final model = data;
    if (model == null) {
      throw const CustomException.parsing(
        message: 'Supply request response missing data.',
        field: 'data',
      );
    }
    return model.toEntity();
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
