import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/additional_income/additional_income_entity.dart';
import '../../../../../domain/entities/additional_income/additional_income_payloads.dart';

part 'submit_additional_income_provider.g.dart';

@riverpod
class SubmitAdditionalIncome extends _$SubmitAdditionalIncome {
  @override
  AsyncValue<AdditionalIncomeEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateAdditionalIncomeRequestEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(createAdditionalIncomeUseCaseProvider)
        .call(request);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Failure.emptyResponse('submit additional income'),
        StackTrace.current,
      ),
    };
  }
}
