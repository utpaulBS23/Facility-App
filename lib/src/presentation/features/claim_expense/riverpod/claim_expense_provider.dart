import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'claim_expense_provider.g.dart';

// WHY today only: GetMyVisitsUseCase is date-scoped (one day per call), and
// there is no "recent visits" endpoint to page through — this optional
// reference-visit picker is limited to today's visits rather than adding
// N sequential day-by-day requests for a non-essential field.
@riverpod
Future<List<VisitSummaryEntity>> claimExpenseTodaysVisits(Ref ref) async {
  final today = DateTime.now();
  final date =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final result = await ref.read(getMyVisitsUseCaseProvider).call(date: date);
  return switch (result) {
    Success(:final data) => data?.visits ?? [],
    Error() => [],
    _ => [],
  };
}

@riverpod
class SubmitTravelExpense extends _$SubmitTravelExpense {
  @override
  AsyncValue<TravelExpenseEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateTravelExpenseRequestEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(createTravelExpenseUseCaseProvider)
        .call(request);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
        Failure.emptyResponse('submit travel expense'),
        StackTrace.current,
      ),
    };
  }
}
