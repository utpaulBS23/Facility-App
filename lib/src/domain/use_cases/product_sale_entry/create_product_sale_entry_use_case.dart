import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../entities/product_sale_entry/product_sale_entry_payloads.dart';
import '../../repositories/product_sale_entry_repository.dart';
import '../partner_use_case.dart';

final class CreateProductSaleEntryUseCase extends PartnerUseCase {
  CreateProductSaleEntryUseCase({
    required this.productSaleEntryRepository,
    required super.authRepository,
  });

  final ProductSaleEntryRepository productSaleEntryRepository;

  Future<Result<List<ProductSaleEntryEntity>, Failure>> call(
    CreateProductSaleEntryRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await productSaleEntryRepository.createProductSaleEntry(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create product sale entry')),
    };
  }
}
