import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/product_sale_entry/product_sale_entry_entity.dart';
import '../entities/product_sale_entry/product_sale_entry_payloads.dart';

abstract base class ProductSaleEntryRepository extends Repository {
  Future<Result<List<ProductSaleEntryEntity>, Failure>> createProductSaleEntry(
    CreateProductSaleEntryRequestEntity request,
  );
}
