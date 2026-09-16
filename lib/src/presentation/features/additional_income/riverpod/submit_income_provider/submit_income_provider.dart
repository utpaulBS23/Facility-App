import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/additional_income/additional_income_payloads.dart';
import '../../../../../domain/entities/product_sale_entry/product_sale_entry_payloads.dart';

part 'submit_income_provider.g.dart';

// WHY one provider, not two: additional-income create and product-sale-entry
// create are the same mutation pattern (one form, one submit button) that
// only differs in which endpoint gets called — branch on which request the
// caller built (the add-income page decides that from its own tab state)
// instead of duplicating the notifier per endpoint.
@riverpod
class SubmitIncome extends _$SubmitIncome {
  @override
  AsyncValue<bool> build() => const AsyncValue.data(false);

  Future<void> submit({
    CreateAdditionalIncomeRequestEntity? incomeRequest,
    CreateProductSaleEntryRequestEntity? productSaleRequest,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = switch (productSaleRequest) {
      final request? => await ref
          .read(createProductSaleEntryUseCaseProvider)
          .call(request),
      null => await ref
          .read(createAdditionalIncomeUseCaseProvider)
          .call(incomeRequest!),
    };

    state = switch (result) {
      Success() => const AsyncValue.data(true),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Exception('Failed to submit income'),
        StackTrace.current,
      ),
    };
  }
}
