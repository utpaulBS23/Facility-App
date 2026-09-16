import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/product_catalog/product_catalog_filter.dart';
import '../../entities/product_catalog/product_catalog_item_entity.dart';
import '../../repositories/product_catalog_repository.dart';
import '../partner_use_case.dart';

final class GetProductCatalogDropdownUseCase extends PartnerUseCase {
  GetProductCatalogDropdownUseCase({
    required this.productCatalogRepository,
    required super.authRepository,
  });

  final ProductCatalogRepository productCatalogRepository;

  Future<Result<List<ProductCatalogItemEntity>, Failure>> call() async {
    final partnerId = getPartnerId();
    final result = await productCatalogRepository.getProductCatalogDropdown(
      ProductCatalogFilter(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get product catalog dropdown')),
    };
  }
}
