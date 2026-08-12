import 'package:dart_mappable/dart_mappable.dart';

import 'supply_pagination_meta_model.dart';

part 'stock_allocation_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class StockAllocationModel with StockAllocationModelMappable {
  const StockAllocationModel({
    required this.id,
    required this.allocationCode,
    required this.facilityId,
    required this.facilityName,
    this.allocatedBy,
    this.allocatedByName,
    this.sourceRequestId,
    this.sourceRequestCode,
    this.notes,
    required this.items,
    required this.totalValue,
    required this.allocatedAt,
  });

  final int id;
  final String allocationCode;
  final int facilityId;
  final String facilityName;
  final int? allocatedBy;
  final String? allocatedByName;
  final int? sourceRequestId;
  final String? sourceRequestCode;
  final String? notes;
  final List<StockAllocationItemModel> items;
  final double totalValue;
  final String allocatedAt;

  static const fromJson = StockAllocationModelMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class StockAllocationItemModel with StockAllocationItemModelMappable {
  const StockAllocationItemModel({
    required this.id,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int id;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double qty;
  final double unitPrice;
  final double lineTotal;

  static const fromJson = StockAllocationItemModelMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class StockAllocationListResponseModel
    with StockAllocationListResponseModelMappable {
  const StockAllocationListResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.meta,
  });

  final bool success;
  final String message;
  final List<StockAllocationModel> data;
  final SupplyPaginationMetaModel? meta;

  static const fromJson = StockAllocationListResponseModelMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class StockAllocationResponseModel with StockAllocationResponseModelMappable {
  const StockAllocationResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final StockAllocationModel data;

  static const fromJson = StockAllocationResponseModelMapper.fromJson;
}
