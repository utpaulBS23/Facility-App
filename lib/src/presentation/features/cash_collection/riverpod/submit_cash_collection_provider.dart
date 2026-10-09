import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../../domain/entities/cash_collection/cash_collection_payloads.dart';
import 'cash_collections_provider.dart';

part 'submit_cash_collection_provider.g.dart';

@riverpod
class SubmitCashCollection extends _$SubmitCashCollection {
  @override
  AsyncValue<CashCollectionEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateCashCollectionRequestEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(createCashCollectionUseCaseProvider)
        .call(request);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Failure.emptyResponse('submit cash collection'),
        StackTrace.current,
      ),
    };

    // WHY: the list tab shows this entry once saved.
    if (state.value != null) ref.invalidate(cashCollectionsProvider);
  }
}
