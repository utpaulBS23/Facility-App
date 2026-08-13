import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/confirm_delivery_request_entity.dart';
import '../entities/supply/create_supply_request_item_entity.dart';
import '../entities/supply/delivery_complaint_entity.dart';
import '../entities/supply/delivery_complaint_status.dart';
import '../entities/supply/delivery_entity.dart';
import '../entities/supply/delivery_status.dart';
import '../entities/supply/file_delivery_complaint_request_entity.dart';
import '../entities/supply/stock_allocation_entity.dart';
import '../entities/supply/stock_item_entity.dart';
import '../entities/supply/supply_request_entity.dart';
import '../entities/supply/supply_request_status.dart';

abstract base class SupplyRepository extends Repository {
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog({
    required int partnerId,
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? pageSize,
  });

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
  getSupplyRequests({
    required int partnerId,
    int? facilityId,
    SupplyRequestStatus? status,
    SupplyUrgency? urgency,
    String? search,
    int? page,
    int? pageSize,
  });

  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest({
    required int partnerId,
    required int facilityId,
    SupplyUrgency? urgency,
    String? notes,
    required List<CreateSupplyRequestItemEntity> items,
  });

  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
    List<CreateSupplyRequestItemEntity>? items,
  });

  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    int partnerId,
    int supplyRequestId, {
    String? notes,
  });

  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> getDeliveries({
    required int partnerId,
    int? facilityId,
    DeliveryStatus? status,
    String? search,
    int? page,
    int? pageSize,
  });

  Future<Result<DeliveryEntity, Failure>> getDeliveryDetails(
    int partnerId,
    int deliveryId,
  );

  Future<Result<DeliveryEntity, Failure>> confirmDelivery(
    int partnerId,
    int deliveryId,
    ConfirmDeliveryRequestEntity request,
  );

  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>>
  getDeliveryComplaints({
    required int partnerId,
    int? facilityId,
    DeliveryComplaintStatus? status,
    String? search,
    int? page,
    int? pageSize,
  });

  Future<Result<DeliveryComplaintEntity, Failure>> getDeliveryComplaintDetails(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> fileDeliveryComplaint(
    int partnerId,
    int deliveryId,
    FileDeliveryComplaintRequestEntity request,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> approveDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId, {
    double? finalQtyReceived,
  });

  Future<Result<DeliveryComplaintEntity, Failure>> rejectDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>>
  getStockAllocations({
    required int partnerId,
    int? facilityId,
    String? search,
    int? page,
    int? pageSize,
  });

  Future<Result<StockAllocationEntity, Failure>> getStockAllocationDetails(
    int partnerId,
    int stockAllocationId,
  );
}
