import '../common/paginated_list_entity.dart';
import '../../../core/utils/localized_text.dart';

/// One product-sale line item (`product_sale_entries` §3.5) — the response
/// shape for both `index` rows and each item in a `store` response array.
class ProductSaleEntryEntity {
  const ProductSaleEntryEntity({
    required this.id,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.entryDate,
    required this.productName,
    this.productNameBn = '',
    required this.unitsSold,
    required this.unitPrice,
    required this.revenue,
    required this.profit,
    required this.recordedByName,
    this.recordedByNameBn = '',
    required this.createdAt,
  });

  final int id;
  final String facilityName;
  final String facilityNameBn;
  final DateTime entryDate;
  final String productName;
  final String productNameBn;
  final int unitsSold;
  final double unitPrice;
  final double revenue;
  // WHY nullable: doc — `profit` is `null` when the product has no
  // `base_price` snapshot on file (SQL SUM ignores NULL terms upstream too).
  final double? profit;
  final String recordedByName;
  final String recordedByNameBn;
  final DateTime createdAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedProductName(String languageCode) =>
      localizedText(languageCode, productName, productNameBn);

  String localizedRecordedByName(String languageCode) =>
      localizedText(languageCode, recordedByName, recordedByNameBn);
}

/// Totals for the Product Income History cards — computed server-side over
/// the entire filtered result set (same facility_id/month filters as the
/// list), not just the current page.
class ProductSaleEntrySummaryEntity {
  const ProductSaleEntrySummaryEntity({
    required this.totalIncome,
    required this.totalUnits,
    required this.totalProfit,
  });

  final double totalIncome;
  final int totalUnits;
  // WHY nullable: doc — `null` when every matching item has no `base_price`
  // snapshot on file.
  final double? totalProfit;
}

/// One row of the "By Facility" breakdown table.
class ProductSaleEntryByFacilityEntity {
  const ProductSaleEntryByFacilityEntity({
    required this.facilityName,
    this.facilityNameBn = '',
    required this.units,
    required this.revenue,
  });

  final String facilityName;
  final String facilityNameBn;
  final int units;
  final double revenue;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}

/// Combined wrapper for `GET /product-sale-entries` — mirrors
/// AdditionalIncomeListResultEntity: one call covers the list, the summary
/// cards, and the by-facility table.
class ProductSaleEntryListResultEntity {
  const ProductSaleEntryListResultEntity({
    required this.list,
    required this.summary,
    required this.byFacility,
  });

  const ProductSaleEntryListResultEntity.empty()
    : list = const PaginatedListEntity.empty(),
      summary = const ProductSaleEntrySummaryEntity(
        totalIncome: 0,
        totalUnits: 0,
        totalProfit: null,
      ),
      byFacility = const [];

  final PaginatedListEntity<ProductSaleEntryEntity> list;
  final ProductSaleEntrySummaryEntity summary;
  final List<ProductSaleEntryByFacilityEntity> byFacility;
}
