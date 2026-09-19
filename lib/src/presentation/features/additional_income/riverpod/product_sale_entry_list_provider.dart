import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/product_sale_entry/product_sale_entry_entity.dart';
import '../../../../domain/entities/product_sale_entry/product_sale_entry_filter.dart';

part 'product_sale_entry_list_provider.g.dart';

@riverpod
class ProductSaleEntryList extends _$ProductSaleEntryList {
  int? _facilityId;
  String? _month;

  @override
  Future<ProductSaleEntryListResultEntity> build() {
    return fetch(facilityId: _facilityId, month: _month);
  }

  Future<ProductSaleEntryListResultEntity> fetch({
    int? facilityId,
    String? month,
  }) async {
    _facilityId = facilityId;
    _month = month;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getProductSaleEntriesUseCaseProvider)
        .call(ProductSaleEntryFilter(facilityId: facilityId, month: month));

    return switch (result) {
      Success(:final data) => _onFetchSuccess(
        data ?? const ProductSaleEntryListResultEntity.empty(),
      ),
      Error(:final error) => _onFetchError(error),
      _ => _onFetchError(Failure.emptyResponse('get product sale entries')),
    };
  }

  ProductSaleEntryListResultEntity _onFetchSuccess(
    ProductSaleEntryListResultEntity result,
  ) {
    state = AsyncValue.data(result);
    return result;
  }

  ProductSaleEntryListResultEntity _onFetchError(Failure error) {
    state = AsyncValue.error(error, StackTrace.current);
    return const ProductSaleEntryListResultEntity.empty();
  }
}
