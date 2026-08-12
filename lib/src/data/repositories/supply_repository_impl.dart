import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/confirm_delivery_request_entity.dart';
import '../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../domain/entities/supply/delivery_complaint_status.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/entities/supply/delivery_status.dart';
import '../../domain/entities/supply/file_delivery_complaint_request_entity.dart';
import '../../domain/entities/supply/stock_allocation_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_status.dart';
import '../../domain/repositories/supply_repository.dart';
import '../extension/supply_request_mapper.dart';
import '../models/supply/delivery_complaint_model.dart';
import '../models/supply/delivery_response_model.dart';
import '../models/supply/stock_allocation_model.dart';
import '../models/supply/stock_item_response_model.dart';
import '../models/supply/supply_response_model.dart';
import '../services/network/rest_client.dart';

final class SupplyRepositoryImpl extends SupplyRepository {
  SupplyRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog({
    required int partnerId,
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? pageSize,
  }) {
    return asyncGuard(() async {
      final response = await remote.getItemCatalog(
        partnerId: partnerId,
        search: search,
        category: category,
        isActive: isActive,
        page: page,
        perPage: pageSize,
      );
      final responseModel = StockItemListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
  getSupplyRequests({
    required int partnerId,
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return asyncGuard(() async {
      final response = await remote.getSupplyRequests(
        partnerId: partnerId,
        facilityId: facilityId,
        status: status?.toWireString(),
        urgency: urgency?.toWireString(),
        search: search,
        page: page,
        perPage: pageSize,
      );
      final responseModel = SupplyRequestListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails(
    int partnerId,
    int supplyRequestId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getSupplyRequestDetails(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest({
    required int partnerId,
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<SupplyRequestItemParams> items,
  }) {
    return asyncGuard(() async {
      final response = await remote.createSupplyRequest(
        partnerId: partnerId,
        body: {
          'facility_id': facilityId,
          if (urgency != null) 'urgency': urgency.toWireString(),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'items': items
              .map(
                (item) => {
                  'stock_item_id': item.stockItemId,
                  'qty_requested': item.qtyRequested,
                  if (item.unitPrice != null) 'unit_price': item.unitPrice,
                },
              )
              .toList(),
        },
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
    List<SupplyRequestItemParams>? items,
  }) {
    return asyncGuard(() async {
      final Map<String, dynamic> body = notes.toDecisionBody();
      if (items != null && items.isNotEmpty) {
        body['items'] = items
            .map(
              (item) => {
                'stock_item_id': item.stockItemId,
                'qty_requested': item.qtyRequested,
                if (item.unitPrice != null) 'unit_price': item.unitPrice,
              },
            )
            .toList();
      }

      final response = await remote.approveSupplyRequest(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
        body: body,
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
  }) {
    return asyncGuard(() async {
      final response = await remote.rejectSupplyRequest(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
        body: notes.toDecisionBody(),
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest(
    int partnerId,
    int supplyRequestId,
  ) {
    return asyncGuard(() async {
      final response = await remote.dispatchSupplyRequest(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
        body: const {},
      );
      final responseModel = DeliveryResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> getDeliveries({
    required int partnerId,
    int? facilityId,
    DeliveryStatus? status,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return asyncGuard(() async {
      final response = await remote.getDeliveries(
        partnerId: partnerId,
        facilityId: facilityId,
        status: status?.toWireString(),
        search: search,
        page: page,
        perPage: pageSize,
      );
      final responseModel = DeliveryListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> getDeliveryDetails(
    int partnerId,
    int deliveryId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getDeliveryDetails(
        partnerId: partnerId,
        deliveryId: deliveryId,
      );
      final responseModel = DeliveryResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> confirmDelivery(
    int partnerId,
    int deliveryId,
    ConfirmDeliveryRequestEntity request,
  ) {
    return asyncGuard(() async {
      final itemsList = request.items;
      final body = <String, dynamic>{
        if (request.receiptPhotoUrl != null)
          'receipt_photo_url': request.receiptPhotoUrl,
        if (request.deliveryNotes != null)
          'delivery_notes': request.deliveryNotes,
        if (itemsList.isNotEmpty)
          'items': itemsList
              .map(
                (item) => {
                  'stock_item_id': item.stockItemId,
                  'qty_received': item.qtyReceived,
                  'is_verified': item.isVerified,
                },
              )
              .toList(),
      };

      final response = await remote.confirmDelivery(
        partnerId: partnerId,
        deliveryId: deliveryId,
        body: body,
      );
      final responseModel = DeliveryResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>>
  getDeliveryComplaints({
    required int partnerId,
    int? facilityId,
    DeliveryComplaintStatus? status,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return asyncGuard(() async {
      final response = await remote.getDeliveryComplaints(
        partnerId: partnerId,
        facilityId: facilityId,
        status: status?.toWireString(),
        search: search,
        page: page,
        perPage: pageSize,
      );
      final responseModel = DeliveryComplaintListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> getDeliveryComplaintDetails(
    int partnerId,
    int deliveryComplaintId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getDeliveryComplaintDetails(
        partnerId: partnerId,
        deliveryComplaintId: deliveryComplaintId,
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> fileDeliveryComplaint(
    int partnerId,
    int deliveryId,
    FileDeliveryComplaintRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.fileDeliveryComplaint(
        partnerId: partnerId,
        deliveryId: deliveryId,
        body: {
          'delivery_item_id': request.deliveryItemId,
          'reported_qty_received': request.reportedQtyReceived,
          'reason': request.reason,
          if (request.evidencePhotoUrl != null)
            'evidence_photo_url': request.evidencePhotoUrl,
        },
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> approveDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId, {
    double? finalQtyReceived,
  }) {
    return asyncGuard(() async {
      final response = await remote.approveDeliveryComplaint(
        partnerId: partnerId,
        deliveryComplaintId: deliveryComplaintId,
        body: finalQtyReceived != null
            ? {'final_qty_received': finalQtyReceived}
            : const {},
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> rejectDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId,
  ) {
    return asyncGuard(() async {
      final response = await remote.rejectDeliveryComplaint(
        partnerId: partnerId,
        deliveryComplaintId: deliveryComplaintId,
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>>
  getStockAllocations({
    required int partnerId,
    int? facilityId,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return asyncGuard(() async {
      final response = await remote.getStockAllocations(
        partnerId: partnerId,
        facilityId: facilityId,
        search: search,
        page: page,
        perPage: pageSize,
      );
      final responseModel = StockAllocationListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<StockAllocationEntity, Failure>> getStockAllocationDetails(
    int partnerId,
    int stockAllocationId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getStockAllocationDetails(
        partnerId: partnerId,
        stockAllocationId: stockAllocationId,
      );
      final responseModel = StockAllocationResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
