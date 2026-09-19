import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/product_catalog/product_catalog_filter.dart';
import '../../domain/entities/product_catalog/product_catalog_item_entity.dart';
import '../../domain/repositories/product_catalog_repository.dart';
import '../extension/product_catalog_mapper.dart';
import '../models/product_catalog/product_catalog_item_model.dart';
import '../services/network/rest_client.dart';

final class ProductCatalogRepositoryImpl extends ProductCatalogRepository {
  ProductCatalogRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<List<ProductCatalogItemEntity>, Failure>> getProductCatalogDropdown(
    ProductCatalogFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getProductCatalogDropdown(
        partnerId: filter.partnerId!,
      );
      final responseModel = ProductCatalogDropdownResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
