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
