import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import 'claim_expense_provider.dart';

part 'travel_expense_review_provider.g.dart';

/// Approving or rejecting a travel expense claim.
@riverpod
class TravelExpenseReview extends _$TravelExpenseReview {
  @override
  AsyncValue<void> build() {
    // WHY: a claim deleted elsewhere can no longer be reviewed — reset so a
    // stale loading/error state doesn't linger on this action provider.
    ref.listen(deleteTravelExpenseProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });
    return const AsyncValue.data(null);
  }

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
  }
}
