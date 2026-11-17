import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import 'claim_expense_provider.dart';
import 'travel_expense_review_provider.dart';

part 'travel_expense_detail_provider.g.dart';

@riverpod
Future<TravelExpenseEntity> travelExpenseDetail(
  Ref ref,
  int travelExpenseId,
) async {
  // WHY harmless on the deleted claim's own detail page: that page pops
  // itself on a successful delete (see TravelExpenseDeleteBar), disposing
  // this autoDispose family member before this listener would re-fetch it.
  ref.listen(deleteTravelExpenseProvider, (previous, next) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      ref.invalidateSelf();
    }
  });

  // WHY: approve/reject changed this claim's status — re-read it.
  ref.listen(travelExpenseReviewProvider, (previous, next) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getTravelExpenseDetailUseCaseProvider)
      .call(travelExpenseId);

  return switch (result) {
    Success(:final data) when data != null => data,
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get travel expense detail'),
  };
}
