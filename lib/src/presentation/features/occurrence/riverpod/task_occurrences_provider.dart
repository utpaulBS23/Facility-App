import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';
import 'task_occurrence_answer_provider.dart';
import 'task_occurrence_reassign_provider.dart';
import 'task_occurrence_submit_provider.dart';

part 'task_occurrences_provider.g.dart';

@riverpod
class TaskOccurrences extends _$TaskOccurrences {
  int? _facilityId;
  String? _date;

  @override
  AsyncValue<TaskOccurrenceListEntity> build() {
    // WHY: reassigning/answering/submitting live in their own providers;
    // this list is the single source of truth for occurrence state, so it
    // refetches itself from the server on every successful action instead
    // of being patched locally.
    void refetchOnSuccess(AsyncValue? previous, AsyncValue next) {
      if (next case AsyncData(value: != null)) {
        // WHY: _facilityId is only ever null before the first fetch() —
        // a mutation can't succeed before the board that offers it has
        // loaded, so this guard never actually skips a real refetch.
        final facilityId = _facilityId;
        if (facilityId != null) fetch(facilityId: facilityId, date: _date);
      }
    }

    ref.listen(taskOccurrenceReassignProvider, refetchOnSuccess);
    ref.listen(taskOccurrenceChecklistAnswerProvider, refetchOnSuccess);
    ref.listen(taskOccurrenceSubmitProvider, refetchOnSuccess);
    return const AsyncValue.loading();
  }

  Future<void> fetch({required int facilityId, String? date}) async {
    _facilityId = facilityId;
    _date = date;
    // WHY: keep the previous list visible during a refetch — dropping it
    // (bare AsyncValue.loading()) made the checklist page fall back to its
    // stale route-arg occurrence and show no loading affordance at all.
    state = AsyncValue<TaskOccurrenceListEntity>.loading().copyWithPrevious(
      state,
    );

    final result = await ref
        .read(getTaskOccurrencesUseCaseProvider)
        .call(facilityId: facilityId, date: date);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error(
              Failure.emptyResponse('load task occurrences'),
              StackTrace.current,
            ),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

}

// WHY: GetPartnerStaffUseCase has no facility scoping — same partner-wide
// staff list every other assign flow uses (see partnerStaffProvider).
@riverpod
Future<List<PartnerStaffEntity>> occurrenceFacilityStaff(Ref ref) async {
  final result = await ref.read(getPartnerStaffUseCaseProvider).call();
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}
