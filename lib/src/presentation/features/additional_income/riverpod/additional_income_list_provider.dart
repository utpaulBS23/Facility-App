import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/additional_income/additional_income_entity.dart';
import '../../../../domain/entities/additional_income/additional_income_filter.dart';
import 'submit_income_provider/submit_additional_income_provider.dart';

part 'additional_income_list_provider.g.dart';

@riverpod
class AdditionalIncomeList extends _$AdditionalIncomeList {
  int? _selectedFacilityId;

  @override
  Future<AdditionalIncomeListResultEntity> build() async {
    ref.listen(submitAdditionalIncomeProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });

    return fetch(facilityId: _selectedFacilityId);
  }

  Future<AdditionalIncomeListResultEntity> fetch({int? facilityId}) async {
    _selectedFacilityId = facilityId;

    state = const AsyncValue.loading();

    final result = await ref
        .read(getAdditionalIncomesUseCaseProvider)
        .call(AdditionalIncomeFilter(facilityId: facilityId));

    return switch (result) {
      Success(:final data) =>
        _onFetchSuccess(data ?? const AdditionalIncomeListResultEntity.empty()),
      Error(:final error) => _onFetchError(error),
      _ => _onFetchError(Failure.emptyResponse('get additional incomes')),
    };
  }

  AdditionalIncomeListResultEntity _onFetchSuccess(
    AdditionalIncomeListResultEntity result,
  ) {
    state = AsyncValue.data(result);
    return result;
  }

  AdditionalIncomeListResultEntity _onFetchError(Failure error) {
    state = AsyncValue.error(error, StackTrace.current);
    return const AdditionalIncomeListResultEntity.empty();
  }
}
