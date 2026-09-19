import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../domain/entities/product_sale_entry/product_sale_entry_payloads.dart';
import '../../domain/repositories/product_sale_entry_repository.dart';
import '../extension/product_sale_entry_mapper.dart';
import '../models/product_sale_entry/product_sale_entry_model.dart';
import '../services/network/rest_client.dart';

final class ProductSaleEntryRepositoryImpl extends ProductSaleEntryRepository {
  ProductSaleEntryRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<List<ProductSaleEntryEntity>, Failure>> createProductSaleEntry(
    CreateProductSaleEntryRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createProductSaleEntry(
        partnerId: request.partnerId!,
        body: request.toBody(),
      );
      final responseModel = ProductSaleEntryListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
