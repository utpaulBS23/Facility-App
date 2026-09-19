import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../entities/product_sale_entry/product_sale_entry_filter.dart';
import '../../repositories/product_sale_entry_repository.dart';
import '../partner_use_case.dart';

final class GetProductSaleEntriesUseCase extends PartnerUseCase {
  GetProductSaleEntriesUseCase({
    required this.productSaleEntryRepository,
    required super.authRepository,
  });

  final ProductSaleEntryRepository productSaleEntryRepository;

  Future<Result<ProductSaleEntryListResultEntity, Failure>> call([
    ProductSaleEntryFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await productSaleEntryRepository.getProductSaleEntries(
      (filter ?? const ProductSaleEntryFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get product sale entries')),
    };
  }
}
