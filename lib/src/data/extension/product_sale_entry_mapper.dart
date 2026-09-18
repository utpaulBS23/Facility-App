import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../domain/entities/product_sale_entry/product_sale_entry_payloads.dart';
import '../models/product_sale_entry/product_sale_entry_model.dart';

extension ProductSaleEntryModelMapper on ProductSaleEntryModel {
  ProductSaleEntryEntity toEntity() {
    return ProductSaleEntryEntity(
      id: id,
      facilityName: facility?.name ?? '',
      entryDate: DateTime.tryParse(entryDate ?? '') ?? DateTime.now(),
      productName: product?.name ?? '',
      unitsSold: unitsSold ?? 0,
      unitPrice: unitPrice ?? 0,
      revenue: revenue ?? 0,
      profit: profit,
      recordedByName: recordedBy?.name ?? '',
      createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    );
  }
}

extension ProductSaleEntryListResponseModelToEntity
    on ProductSaleEntryListResponseModel {
  List<ProductSaleEntryEntity> toEntity() {
    return (data ?? const []).map((model) => model.toEntity()).toList();
  }

  ProductSaleEntryListResultEntity toListResult() {
    final items = toEntity();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return ProductSaleEntryListResultEntity(
      list: PaginatedListEntity<ProductSaleEntryEntity>(
        items: items,
        currentPage: curPage,
        pageSize: size,
        totalRecords: total,
        hasMore: hasMore,
      ),
      summary: (summary ?? const ProductSaleEntrySummaryModel()).toEntity(),
      byFacility:
          (byFacility ?? const []).map((row) => row.toEntity()).toList(),
    );
  }
}

extension ProductSaleEntrySummaryModelMapper on ProductSaleEntrySummaryModel {
  ProductSaleEntrySummaryEntity toEntity() {
    return ProductSaleEntrySummaryEntity(
      totalIncome: totalIncome ?? 0,
      totalUnits: totalUnits ?? 0,
      totalProfit: totalProfit,
    );
  }
}

extension ProductSaleEntryByFacilityModelMapper on ProductSaleEntryByFacilityModel {
  ProductSaleEntryByFacilityEntity toEntity() {
    return ProductSaleEntryByFacilityEntity(
      facilityName: facility?.name ?? '',
      units: units ?? 0,
      revenue: revenue ?? 0,
    );
  }
}

extension CreateProductSaleEntryRequestEntityMapper
    on CreateProductSaleEntryRequestEntity {
  Map<String, dynamic> toBody() => {
    'facility_id': facilityId,
    'entry_date': entryDate.toIso8601String().split('T').first,
    'items': items.map((item) => item.toBody()).toList(),
  };
}

extension CreateProductSaleEntryItemEntityMapper
    on CreateProductSaleEntryItemEntity {
  Map<String, dynamic> toBody() => {
    'product_id': productId,
    'units_sold': unitsSold,
    'unit_price': unitPrice,
  };
}
