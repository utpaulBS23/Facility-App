import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../domain/entities/supply/delivery_entity.dart';
import '../../domain/entities/supply/stock_allocation_entity.dart';
import '../../domain/entities/supply/stock_item_entity.dart';
import '../../domain/entities/supply/supply_filters.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_payloads.dart';
import '../../domain/entities/supply/supply_request_summary_entity.dart';
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
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog(
    ItemCatalogFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getItemCatalog(
        partnerId: filter.partnerId!,
        search: filter.search,
        category: filter.category,
        isActive: filter.isActive,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = StockItemListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
  getSupplyRequests(SupplyRequestQueryFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getSupplyRequests(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        status: filter.status?.toWireString(),
        urgency: filter.urgency?.toWireString(),
        search: filter.search,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = SupplyRequestListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestSummaryEntity, Failure>> getSupplyRequestSummary({
    required int partnerId,
    int? facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getSupplyRequestSummary(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      final responseModel = SupplyRequestSummaryResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails({
    required int partnerId,
    required int supplyRequestId,
  }) {
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
  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest(
    CreateSupplyRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createSupplyRequest(
        partnerId: request.partnerId!,
        body: request.toBody(),
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    ApproveSupplyRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.approveSupplyRequest(
        partnerId: request.partnerId!,
        supplyRequestId: request.supplyRequestId,
        body: request.toBody(),
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    RejectSupplyRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.rejectSupplyRequest(
        partnerId: request.partnerId!,
        supplyRequestId: request.supplyRequestId,
        body: request.notes.toDecisionBody(),
      );
      final responseModel = SupplyRequestResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest({
    required int partnerId,
    required int supplyRequestId,
  }) {
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
  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> getDeliveries(
    DeliveryFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getDeliveries(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        status: filter.status?.toWireString(),
        search: filter.search,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = DeliveryListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryEntity, Failure>> getDeliveryDetails({
    required int partnerId,
    required int deliveryId,
  }) {
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
    ConfirmDeliveryRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.confirmDelivery(
        partnerId: request.partnerId!,
        deliveryId: request.deliveryId,
        body: request.toBody(),
      );
      final responseModel = DeliveryResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>>
  getDeliveryComplaints(DeliveryComplaintFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getDeliveryComplaints(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        status: filter.status?.toWireString(),
        search: filter.search,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = DeliveryComplaintListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> getDeliveryComplaintDetails({
    required int partnerId,
    required int deliveryComplaintId,
  }) {
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
    FileDeliveryComplaintRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.fileDeliveryComplaint(
        partnerId: request.partnerId!,
        deliveryId: request.deliveryId,
        body: request.toBody(),
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> approveDeliveryComplaint(
    ApproveDeliveryComplaintRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.approveDeliveryComplaint(
        partnerId: request.partnerId!,
        deliveryComplaintId: request.deliveryComplaintId,
        body: request.toBody(),
      );
      final responseModel = DeliveryComplaintResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<DeliveryComplaintEntity, Failure>> rejectDeliveryComplaint({
    required int partnerId,
    required int deliveryComplaintId,
  }) {
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
  getStockAllocations(StockAllocationFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getStockAllocations(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        search: filter.search,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = StockAllocationListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<StockAllocationEntity, Failure>> getStockAllocationDetails({
    required int partnerId,
    required int stockAllocationId,
  }) {
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
