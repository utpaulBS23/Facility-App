import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/facility_expense/facility_expense_entity.dart';

part 'submit_facility_expense_provider.g.dart';

@riverpod
class SubmitFacilityExpense extends _$SubmitFacilityExpense {
  @override
  AsyncValue<FacilityExpenseEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateFacilityExpenseRequestEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(createFacilityExpenseUseCaseProvider)
        .call(request);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Failure.emptyResponse('submit facility expense'),
        StackTrace.current,
      ),
    };
  }
}
