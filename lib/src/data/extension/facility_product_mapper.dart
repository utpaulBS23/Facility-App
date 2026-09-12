import '../../domain/entities/facility_product/facility_product_entity.dart';
import '../models/facility_product/facility_product_model.dart';

extension FacilityProductModelMapperExt on FacilityProductModel {
  FacilityProductEntity toEntity() {
    return FacilityProductEntity(
      id: id,
      productId: product?.id ?? 0,
      productName: product?.name ?? '',
      category: product?.category ?? '',
      price: price ?? 0,
      stockQuantity: stockQuantity ?? 0,
    );
  }
}

extension FacilityProductListResponseModelToEntity
    on FacilityProductListResponseModel {
  List<FacilityProductEntity> toEntity() {
    return (data ?? const []).map((model) => model.toEntity()).toList();
  }
}
