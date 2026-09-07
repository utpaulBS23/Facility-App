import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import 'claim_expense_provider.dart';

part 'travel_expenses_list_provider.g.dart';

/// Fetches the full claim list once (`per_page=100`, no server-side status
/// filter) — status filtering happens client-side on this same set so the
/// stat cards (computed over everything) and the status-filtered list can
/// both read off one fetch. See `GetTravelExpensesUseCase`.
@riverpod
class TravelExpensesList extends _$TravelExpensesList {
  @override
  Future<List<TravelExpenseEntity>> build() async {
    ref.listen(submitTravelExpenseProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null) {
        ref.invalidateSelf();
      }
    });

    return fetch();
  }

  Future<List<TravelExpenseEntity>> fetch() async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(getTravelExpensesUseCaseProvider)
        .call(const TravelExpenseFilter());

    final list = result.when(
      success: (data) => data ?? const [],
      error: (error) => throw error,
    );

    state = AsyncValue.data(list);
    return list;
  }
}
