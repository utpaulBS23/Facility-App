import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/product_catalog/product_catalog_filter.dart';
import '../entities/product_catalog/product_catalog_item_entity.dart';

abstract base class ProductCatalogRepository extends Repository {
  Future<Result<List<ProductCatalogItemEntity>, Failure>> getProductCatalogDropdown(
    ProductCatalogFilter filter,
  );
}
