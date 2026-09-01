import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'claim_expense_provider.g.dart';

@riverpod
Future<List<MasterDataItemEntity>> claimExpenseTransportModes(Ref ref) async {
  final result = await ref
      .read(getMasterDataItemsUseCaseProvider)
      .call(category: 'transportMode');
  return switch (result) {
    Success(:final data) => data ?? [],
    _ => [],
  };
}

// WHY facility-scoped, not date-scoped: matches the documented reference-
// visit filter (facility_id + assigned_to=self + status=completed) — a
// claim is filed against a specific destination facility, and the visit it
// references may have been completed any day, not just today.
@riverpod
Future<List<VisitSummaryEntity>> claimExpenseReferenceVisits(
  Ref ref,
  int facilityId,
) async {
  final userId = ref.read(getCurrentUserUseCaseProvider).call()?.id;
  if (userId == null) return [];

  final result = await ref
      .read(getMyVisitsUseCaseProvider)
      .call(status: 'completed', facilityId: facilityId, assignedTo: userId);
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
