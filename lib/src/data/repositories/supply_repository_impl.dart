import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../domain/entities/stock/facility_stock_balance_filter.dart';
import '../../domain/entities/supply/supply_request_entity.dart';
import '../../domain/entities/supply/supply_request_status.dart';
import '../../domain/repositories/supply_repository.dart';
import '../extension/facility_stock_balance_mapper.dart';
import '../extension/supply_request_mapper.dart';
import '../models/stock/facility_stock_balance_model.dart';
import '../models/supply/supply_response_models.dart';
import '../services/network/rest_client.dart';

final class SupplyRepositoryImpl extends SupplyRepository {
  SupplyRepositoryImpl({required this.remote});

  final RestClient remote;

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
      final responseModel =
          SupplyRequestListResponseModel.fromJson(response.data);

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
    required List<CreateSupplyRequestItemParams> items,
  }) {
    return asyncGuard(() async {
      final response = await remote.createSupplyRequest(
        partnerId: partnerId,
        body: {
          'facility_id': facilityId,
          if (urgency != null) 'urgency': urgency.toWireString(),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'items': items
              .map((item) => {
                    'stock_item_id': item.stockItemId,
                    'qty_requested': item.qtyRequested,
                    if (item.unitPrice != null) 'unit_price': item.unitPrice,
                  })
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
  }) {
    return asyncGuard(() async {
      final response = await remote.approveSupplyRequest(
        partnerId: partnerId,
        supplyRequestId: supplyRequestId,
        body: notes.toDecisionBody(),
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
  Future<Result<FacilityStockBalancePageEntity, Failure>>
      getFacilityStockBalance(
    FacilityStockBalanceFilter filter,
  ) {
    return asyncGuard(() async {
      final partnerId = filter.partnerId ?? 0;
      final response = await remote.getFacilityStockBalance(
        partnerId: partnerId,
        facilityId: filter.facilityId,
        stockItemId: filter.stockItemId,
        status: filter.status,
        page: filter.page,
        perPage: filter.perPage,
      );

      final Map<String, dynamic> dataMap =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : {};
      final List<dynamic> itemsList = dataMap['data'] as List<dynamic>? ?? [];
      final Map<String, dynamic>? summaryMap =
          dataMap['summary'] as Map<String, dynamic>?;

      final items = itemsList
          .map((json) =>
              FacilityStockBalanceModel.fromJson(json as Map<String, dynamic>)
                  .toEntity())
          .toList();

      final summary = summaryMap != null
          ? FacilityStockBalanceSummaryModel.fromJson(summaryMap).toEntity()
          : null;

      return FacilityStockBalancePageEntity(items: items, summary: summary);
    });
  }
}
