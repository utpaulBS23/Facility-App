import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/checklist_entity.dart';

part 'inspection_checklist_provider.g.dart';

class InspectionChecklistState {
  const InspectionChecklistState({
    this.checklist,
    this.starAnswers = const {},
    this.yesNoAnswers = const {},
    this.proofImages = const {},
    this.confirmedPoints = const {},
    this.savingItemIds = const {},
    this.itemSaveErrors = const {},
    this.isLoadingChecklist = false,
    this.checklistError,
    this.isSubmitting = false,
    this.submitError,
    this.submitSuccess = false,
  });

  final ChecklistEntity? checklist;
  final Map<int, int> starAnswers;
  final Map<int, bool> yesNoAnswers;
  final Map<int, List<XFile>> proofImages;
  // Server-confirmed points per item; drives total score display.
  final Map<int, int> confirmedPoints;
  final Set<int> savingItemIds;
  final Map<int, Failure> itemSaveErrors;
  final bool isLoadingChecklist;
  final Failure? checklistError;
  final bool isSubmitting;
  final Failure? submitError;
  final bool submitSuccess;

  int get totalAnswerableCount =>
      checklist?.items
          .where((i) => i.answerType != ChecklistAnswerType.repairWork)
          .length ??
      0;

  int get answeredCount {
    if (checklist == null) return 0;
    int count = 0;
    for (final item in checklist!.items) {
      if (item.answerType == ChecklistAnswerType.repairWork) continue;
      if (item.answerType == ChecklistAnswerType.star &&
          starAnswers.containsKey(item.id)) {
        count++;
      }
      if (item.answerType == ChecklistAnswerType.yesNo &&
          yesNoAnswers.containsKey(item.id)) {
        count++;
      }
    }
    return count;
  }

  bool get isComplete => answeredCount == totalAnswerableCount;

  int get currentScore => confirmedPoints.values.fold(0, (sum, p) => sum + p);

  InspectionChecklistState copyWith({
    ChecklistEntity? checklist,
    Map<int, int>? starAnswers,
    Map<int, bool>? yesNoAnswers,
    Map<int, List<XFile>>? proofImages,
    Map<int, int>? confirmedPoints,
    Set<int>? savingItemIds,
    Map<int, Failure>? itemSaveErrors,
    bool? isLoadingChecklist,
    Failure? checklistError,
    bool? isSubmitting,
    Failure? submitError,
    bool? submitSuccess,
    bool clearChecklistError = false,
    bool clearSubmitError = false,
  }) {
    return InspectionChecklistState(
      checklist: checklist ?? this.checklist,
      starAnswers: starAnswers ?? this.starAnswers,
      yesNoAnswers: yesNoAnswers ?? this.yesNoAnswers,
      proofImages: proofImages ?? this.proofImages,
      confirmedPoints: confirmedPoints ?? this.confirmedPoints,
      savingItemIds: savingItemIds ?? this.savingItemIds,
      itemSaveErrors: itemSaveErrors ?? this.itemSaveErrors,
      isLoadingChecklist: isLoadingChecklist ?? this.isLoadingChecklist,
      checklistError: clearChecklistError
          ? null
          : (checklistError ?? this.checklistError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }
}

@riverpod
class InspectionChecklist extends _$InspectionChecklist {
  @override
  InspectionChecklistState build() =>
      const InspectionChecklistState(isLoadingChecklist: true);

  Future<void> loadChecklist({required int visitId}) async {
    state = state.copyWith(isLoadingChecklist: true, clearChecklistError: true);

    final Result<ChecklistEntity, Failure> result = await ref
        .read(getChecklistUseCaseProvider)
        .call(visitId: visitId);

    state = result.when(
      success: (data) {
        final existingStarAnswers = <int, int>{};
        final existingYesNoAnswers = <int, bool>{};
        final existingPoints = <int, int>{};
        for (final item in data?.items ?? []) {
          if (item.existingRating != null) {
            existingStarAnswers[item.id] = item.existingRating!;
          }
          if (item.existingBoolAnswer != null) {
            existingYesNoAnswers[item.id] = item.existingBoolAnswer!;
          }
          if (item.existingPointsAwarded != null) {
            existingPoints[item.id] = item.existingPointsAwarded!;
          }
        }
        return state.copyWith(
          isLoadingChecklist: false,
          checklist: data,
          starAnswers: existingStarAnswers,
          yesNoAnswers: existingYesNoAnswers,
          confirmedPoints: existingPoints,
        );
      },
      error: (err) =>
          state.copyWith(isLoadingChecklist: false, checklistError: err),
    );
  }

  void setStarRatingLocal({required int itemId, required int rating}) {
    final updated = Map<int, int>.from(state.starAnswers);
    if (updated[itemId] == rating) {
      updated.remove(itemId);
    } else {
      updated[itemId] = rating;
    }
    state = state.copyWith(starAnswers: updated);
  }

  void setYesNoLocal({required int itemId, required bool value}) {
    state = state.copyWith(
      yesNoAnswers: Map<int, bool>.from(state.yesNoAnswers)..[itemId] = value,
    );
  }

  Future<void> saveStarRating({
    required int visitId,
    required int itemId,
    required int rating,
  }) async {
    final previousRating = state.starAnswers[itemId];
    final isSameRating = previousRating == rating;
    final updatedStarAnswers = Map<int, int>.from(state.starAnswers);
    if (isSameRating) {
      updatedStarAnswers.remove(itemId);
    } else {
      updatedStarAnswers[itemId] = rating;
    }

    state = state.copyWith(
      starAnswers: updatedStarAnswers,
      savingItemIds: Set<int>.from(state.savingItemIds)..add(itemId),
      itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
        ..remove(itemId),
    );

    final result = await ref
        .read(saveChecklistItemResponseUseCaseProvider)
        .call(
          visitId: visitId,
          itemId: itemId,
          ratingValue: isSameRating ? 0 : rating,
          photoPath: state.proofImages[itemId]?.lastOrNull?.path,
        );

    final doneSaving = Set<int>.from(state.savingItemIds)..remove(itemId);

    state = result.when(
      success: (data) {
        if (data == null) return state.copyWith(savingItemIds: doneSaving);
        final newPoints = Map<int, int>.from(state.confirmedPoints);
        if (data.pointsAwarded > 0) {
          newPoints[itemId] = data.pointsAwarded;
        } else {
          newPoints.remove(itemId);
        }
        return state.copyWith(
          savingItemIds: doneSaving,
          confirmedPoints: newPoints,
          proofImages: Map<int, List<XFile>>.from(state.proofImages)
            ..remove(itemId),
          checklist: _withUpdatedItemProof(
            itemId: itemId,
            hasProof: data.hasProof,
          ),
        );
      },
      error: (err) {
        // WHY: restore the pre-tap value, not just remove — the user may have
        // changed from one rating to another, in which case remove would lose
        // the prior confirmed answer instead of reverting to it.
        final revertedAnswers = Map<int, int>.from(state.starAnswers);
        if (previousRating == null) {
          revertedAnswers.remove(itemId);
        } else {
          revertedAnswers[itemId] = previousRating;
        }
        return state.copyWith(
          starAnswers: revertedAnswers,
          savingItemIds: doneSaving,
          itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
            ..[itemId] = err,
        );
      },
    );
  }

  Future<void> saveYesNo({
    required int visitId,
    required int itemId,
    required bool value,
  }) async {
    final previousYesNo = state.yesNoAnswers[itemId];

    state = state.copyWith(
      yesNoAnswers: Map<int, bool>.from(state.yesNoAnswers)..[itemId] = value,
      savingItemIds: Set<int>.from(state.savingItemIds)..add(itemId),
      itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
        ..remove(itemId),
    );

    final result = await ref
        .read(saveChecklistItemResponseUseCaseProvider)
        .call(
          visitId: visitId,
          itemId: itemId,
          booleanValue: value,
        );

    final doneSaving = Set<int>.from(state.savingItemIds)..remove(itemId);

    state = result.when(
      success: (data) {
        if (data == null) return state.copyWith(savingItemIds: doneSaving);
        final newPoints = Map<int, int>.from(state.confirmedPoints);
        if (data.pointsAwarded > 0) {
          newPoints[itemId] = data.pointsAwarded;
        } else {
          newPoints.remove(itemId);
        }
        return state.copyWith(
          savingItemIds: doneSaving,
          confirmedPoints: newPoints,
        );
      },
      error: (err) {
        final revertedYesNo = Map<int, bool>.from(state.yesNoAnswers);
        if (previousYesNo == null) {
          revertedYesNo.remove(itemId);
        } else {
          revertedYesNo[itemId] = previousYesNo;
        }
        return state.copyWith(
          yesNoAnswers: revertedYesNo,
          savingItemIds: doneSaving,
          itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
            ..[itemId] = err,
        );
      },
    );
  }

  // WHY: separate from saveStarRating/saveYesNo to avoid toggle logic when
  // submitting via the explicit submit button (always-proof items).
  Future<void> submitItemAnswer({
    required int visitId,
    required int itemId,
  }) async {
    if (!ref.hasPermission(AppPermission.checklistResponseSubmit)) {
      state = state.copyWith(
        itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
          ..[itemId] = Failure.permissionDenied,
      );
      return;
    }

    final ratingValue = state.starAnswers[itemId];
    final booleanValue = state.yesNoAnswers[itemId];
    if (ratingValue == null && booleanValue == null) return;

    state = state.copyWith(
      savingItemIds: Set<int>.from(state.savingItemIds)..add(itemId),
      itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
        ..remove(itemId),
    );

    final result = await ref
        .read(saveChecklistItemResponseUseCaseProvider)
        .call(
          visitId: visitId,
          itemId: itemId,
          ratingValue: ratingValue,
          booleanValue: booleanValue,
          photoPath: state.proofImages[itemId]?.lastOrNull?.path,
        );

    final doneSaving = Set<int>.from(state.savingItemIds)..remove(itemId);

    state = result.when(
      success: (data) {
        if (data == null) return state.copyWith(savingItemIds: doneSaving);
        final newPoints = Map<int, int>.from(state.confirmedPoints);
        if (data.pointsAwarded > 0) {
          newPoints[itemId] = data.pointsAwarded;
        } else {
          newPoints.remove(itemId);
        }
        return state.copyWith(
          savingItemIds: doneSaving,
          confirmedPoints: newPoints,
          proofImages: Map<int, List<XFile>>.from(state.proofImages)
            ..remove(itemId),
          checklist: _withUpdatedItemProof(
            itemId: itemId,
            hasProof: data.hasProof,
          ),
        );
      },
      error: (err) => state.copyWith(
        savingItemIds: doneSaving,
        itemSaveErrors: Map<int, Failure>.from(state.itemSaveErrors)
          ..[itemId] = err,
      ),
    );
  }

  Future<void> pickProofImage({required int itemId}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // WHY: replace, not append — only lastOrNull is ever uploaded; accumulating
    // stale XFile handles wastes memory and silently discards all but the last.
    final updated = Map<int, List<XFile>>.from(state.proofImages);
    updated[itemId] = [image];
    state = state.copyWith(proofImages: updated);
  }

  void removeProofImage({required int itemId}) {
    final updated = Map<int, List<XFile>>.from(state.proofImages);
    final list = List<XFile>.from(updated[itemId] ?? []);
    if (list.isNotEmpty) list.removeLast();
    if (list.isEmpty) {
      updated.remove(itemId);
    } else {
      updated[itemId] = list;
    }
    state = state.copyWith(proofImages: updated);
  }

  ChecklistEntity? _withUpdatedItemProof({
    required int itemId,
    required bool hasProof,
  }) {
    final checklist = state.checklist;
    if (checklist == null) return null;
    final updatedItems = checklist.items.map((item) {
      if (item.id != itemId) return item;
      return ChecklistItemEntity(
        id: item.id,
        question: item.question,
        answerType: item.answerType,
        order: item.order,
        maxPoints: item.maxPoints,
        proofPolicy: item.proofPolicy,
        existingRating: item.existingRating,
        existingBoolAnswer: item.existingBoolAnswer,
        existingPointsAwarded: item.existingPointsAwarded,
        existingMediaUrls: item.existingMediaUrls,
        hasProof: hasProof,
      );
    }).toList();
    return ChecklistEntity(
      maxScore: checklist.maxScore,
      items: updatedItems,
      issues: checklist.issues,
    );
  }

  Future<void> submit({required int visitId}) async {
    if (!state.isComplete) return;

    if (!ref.hasPermission(AppPermission.checklistResponseSubmit)) {
      state = state.copyWith(submitError: Failure.permissionDenied);
      return;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    final answers = [
      for (final e in state.starAnswers.entries)
        ChecklistAnswerRequestEntity(itemId: e.key, starRating: e.value),
      for (final e in state.yesNoAnswers.entries)
        ChecklistAnswerRequestEntity(itemId: e.key, yesNoAnswer: e.value),
    ];

    final Result<void, Failure> result = await ref
        .read(submitChecklistUseCaseProvider)
        .call(
          visitId: visitId,
          request: ChecklistSubmitRequestEntity(answers: answers),
        );

    state = result.when(
      success: (_) => state.copyWith(isSubmitting: false, submitSuccess: true),
      error: (err) => state.copyWith(isSubmitting: false, submitError: err),
    );
  }
}
