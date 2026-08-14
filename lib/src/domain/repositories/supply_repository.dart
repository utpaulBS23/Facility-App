import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/delivery_complaint_entity.dart';
import '../entities/supply/delivery_entity.dart';
import '../entities/supply/stock_allocation_entity.dart';
import '../entities/supply/stock_item_entity.dart';
import '../entities/supply/supply_filters.dart';
import '../entities/supply/supply_request_entity.dart';
import '../entities/supply/supply_request_payloads.dart';

abstract base class SupplyRepository extends Repository {
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog(
    ItemCatalogFilter filter,
  );

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
  getSupplyRequests(
    SupplyRequestQueryFilter filter,
  );

  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest(
    CreateSupplyRequestEntity request,
  );

  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    ApproveSupplyRequestEntity request,
  );

  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    RejectSupplyRequestEntity request,
  );

  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> getDeliveries(
    DeliveryFilter filter,
  );

  Future<Result<DeliveryEntity, Failure>> getDeliveryDetails(
    int partnerId,
    int deliveryId,
  );

  Future<Result<DeliveryEntity, Failure>> confirmDelivery(
    ConfirmDeliveryRequestEntity request,
  );

  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>>
  getDeliveryComplaints(
    DeliveryComplaintFilter filter,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> getDeliveryComplaintDetails(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> fileDeliveryComplaint(
    FileDeliveryComplaintRequestEntity request,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> approveDeliveryComplaint(
    ApproveDeliveryComplaintRequestEntity request,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> rejectDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>>
  getStockAllocations(
    StockAllocationFilter filter,
  );

  Future<Result<StockAllocationEntity, Failure>> getStockAllocationDetails(
    int partnerId,
    int stockAllocationId,
  );
}
