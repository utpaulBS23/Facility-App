import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import 'travel_expense_detail_provider.dart';
import 'travel_expenses_list_provider.dart';

part 'travel_expense_review_provider.g.dart';

/// Approving or rejecting a travel expense claim.
@riverpod
class TravelExpenseReview extends _$TravelExpenseReview {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> approve(int travelExpenseId) {
    return _review(
      travelExpenseId,
      () => ref.read(approveTravelExpenseUseCaseProvider)(travelExpenseId),
    );
  }

  Future<void> reject(int travelExpenseId, String note) {
    return _review(
      travelExpenseId,
      () => ref.read(rejectTravelExpenseUseCaseProvider)(travelExpenseId, note),
    );
  }

  Future<void> _review(
    int travelExpenseId,
    Future<Result<void, Failure>> Function() action,
  ) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await action();

    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Failure.emptyResponse('review travel expense'),
        StackTrace.current,
      ),
    };

    // WHY: the claim's status changed, so the details page and the list that
    // shows it must read it again.
    if (!state.hasError) {
      ref.invalidate(travelExpenseDetailProvider(travelExpenseId));
      ref.invalidate(travelExpensesListProvider);
    }
  }
}
