import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';

part 'task_occurrences_provider.g.dart';

@riverpod
class TaskOccurrences extends _$TaskOccurrences {
  int? _facilityId;
  String? _date;

  @override
  AsyncValue<TaskOccurrenceListEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required int facilityId, String? date}) async {
    _facilityId = facilityId;
    _date = date;
    state = const AsyncValue.loading();

    final Result<TaskOccurrenceListEntity, Failure> result = await ref
        .read(getTaskOccurrencesUseCaseProvider)
        .call(facilityId: facilityId, date: date);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error(Failure.emptyResponse('load task occurrences'), StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  void _replace(TaskOccurrenceEntity occurrence) {
    final previous = state.valueOrNull;
    if (previous == null) return;

    state = AsyncValue.data(
      TaskOccurrenceListEntity(
        occurrences: previous.occurrences
            .map((o) => o.id == occurrence.id ? occurrence : o)
            .toList(),
        stats: previous.stats,
      ),
    );
  }

  Future<Result<TaskOccurrenceEntity, Failure>> reassign({
    required int taskOccurrenceId,
    required int assignedTo,
  }) async {
    final result = await ref
        .read(reassignTaskOccurrenceUseCaseProvider)
        .call(taskOccurrenceId: taskOccurrenceId, assignedTo: assignedTo);

    if (result case Success(:final data) when data != null) {
      _replace(data);
    }
    return result;
  }

  Future<Result<ChecklistItemAnswerEntity, Failure>> answerChecklistItem({
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  }) async {
    final result = await ref
        .read(answerTaskOccurrenceChecklistItemUseCaseProvider)
        .call(
          taskOccurrenceId: taskOccurrenceId,
          itemId: itemId,
          ratingValue: ratingValue,
          booleanValue: booleanValue,
          textValue: textValue,
          photoPath: photoPath,
          alt: alt,
        );

    if (result case Success(:final data) when data != null) {
      final previous = state.valueOrNull;
      TaskOccurrenceEntity? occurrence;
      for (final o in previous?.occurrences ?? const <TaskOccurrenceEntity>[]) {
        if (o.id == taskOccurrenceId) {
          occurrence = o;
          break;
        }
      }
      final items = occurrence?.checklistItems;
      if (occurrence != null && items != null) {
        _replace(
          occurrence.copyWith(
            checklistItems: items
                .map((item) => item.id == itemId
                    ? TaskOccurrenceChecklistItemEntity(
                        id: item.id,
                        label: item.label,
                        responseType: item.responseType,
                        response: data,
                      )
                    : item)
                .toList(),
          ),
        );
      }
    }
    return result;
  }

  Future<Result<TaskOccurrenceEntity, Failure>> submit({
    required int taskOccurrenceId,
  }) async {
    final result = await ref
        .read(submitTaskOccurrenceUseCaseProvider)
        .call(taskOccurrenceId: taskOccurrenceId);

    final facilityId = _facilityId;
    if (result case Success() when facilityId != null) {
      await fetch(facilityId: facilityId, date: _date);
    }
    return result;
  }
}

@riverpod
Future<List<PartnerStaffEntity>> occurrenceFacilityStaff(
  Ref ref,
  int facilityId,
) async {
  final result = await ref.read(getPartnerStaffUseCaseProvider).call();
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}
