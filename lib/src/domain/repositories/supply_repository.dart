import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/supply/approve_delivery_complaint_request_entity.dart';
import '../entities/supply/approve_supply_request_entity.dart';
import '../entities/supply/confirm_delivery_request_entity.dart';
import '../entities/supply/create_supply_request_entity.dart';
import '../entities/supply/delivery_complaint_entity.dart';
import '../entities/supply/delivery_complaint_filter.dart';
import '../entities/supply/delivery_entity.dart';
import '../entities/supply/delivery_filter.dart';
import '../entities/supply/file_delivery_complaint_request_entity.dart';
import '../entities/supply/item_catalog_filter.dart';
import '../entities/supply/reject_supply_request_entity.dart';
import '../entities/supply/stock_allocation_entity.dart';
import '../entities/supply/stock_allocation_filter.dart';
import '../entities/supply/stock_item_entity.dart';
import '../entities/supply/supply_request_entity.dart';
import '../entities/supply/supply_request_filter.dart';

abstract base class SupplyRepository extends Repository {
  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> getItemCatalog(
    int partnerId,
    ItemCatalogFilter? filter,
  );

  Future<Result<PaginatedListEntity<SupplyRequestEntity>, Failure>>
  getSupplyRequests(
    int partnerId,
    SupplyRequestQueryFilter? filter,
  );

  Future<Result<SupplyRequestEntity, Failure>> getSupplyRequestDetails(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<SupplyRequestEntity, Failure>> createSupplyRequest(
    int partnerId,
    CreateSupplyRequestEntity request,
  );

  Future<Result<SupplyRequestEntity, Failure>> approveSupplyRequest(
    int partnerId,
    ApproveSupplyRequestEntity request,
  );

  Future<Result<SupplyRequestEntity, Failure>> rejectSupplyRequest(
    int partnerId,
    RejectSupplyRequestEntity request,
  );

  Future<Result<DeliveryEntity, Failure>> dispatchSupplyRequest(
    int partnerId,
    int supplyRequestId,
  );

  Future<Result<PaginatedListEntity<DeliveryEntity>, Failure>> getDeliveries(
    int partnerId,
    DeliveryFilter? filter,
  );

  Future<Result<DeliveryEntity, Failure>> getDeliveryDetails(
    int partnerId,
    int deliveryId,
  );

  Future<Result<DeliveryEntity, Failure>> confirmDelivery(
    int partnerId,
    ConfirmDeliveryRequestEntity request,
  );

  Future<Result<PaginatedListEntity<DeliveryComplaintEntity>, Failure>>
  getDeliveryComplaints(
    int partnerId,
    DeliveryComplaintFilter? filter,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> getDeliveryComplaintDetails(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> fileDeliveryComplaint(
    int partnerId,
    FileDeliveryComplaintRequestEntity request,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> approveDeliveryComplaint(
    int partnerId,
    ApproveDeliveryComplaintRequestEntity request,
  );

  Future<Result<DeliveryComplaintEntity, Failure>> rejectDeliveryComplaint(
    int partnerId,
    int deliveryComplaintId,
  );

  Future<Result<PaginatedListEntity<StockAllocationEntity>, Failure>>
  getStockAllocations(
    int partnerId,
    StockAllocationFilter? filter,
  );

  Future<Result<StockAllocationEntity, Failure>> getStockAllocationDetails(
    int partnerId,
    int stockAllocationId,
  );
}
