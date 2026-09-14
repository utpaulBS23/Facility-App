import '../../domain/entities/product_catalog/product_catalog_item_entity.dart';
import '../models/product_catalog/product_catalog_item_model.dart';

extension ProductCatalogItemModelMapper on ProductCatalogItemModel {
  ProductCatalogItemEntity toEntity() {
    return ProductCatalogItemEntity(
      id: id,
      name: name ?? '',
      category: category ?? '',
      defaultPrice: defaultPrice ?? 0,
    );
  }
}

extension ProductCatalogDropdownResponseModelToEntity
    on ProductCatalogDropdownResponseModel {
  List<ProductCatalogItemEntity> toEntity() {
    return (data ?? const []).map((model) => model.toEntity()).toList();
  }
}
