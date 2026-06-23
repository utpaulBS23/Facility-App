import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/checklist_entity.dart';

part 'inspection_checklist_provider.g.dart';

class InspectionChecklistState {
  const InspectionChecklistState({
    this.checklist,
    this.starAnswers = const {},
    this.yesNoAnswers = const {},
    this.proofImages = const {},
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
  final bool isLoadingChecklist;
  final String? checklistError;
  final bool isSubmitting;
  final String? submitError;
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

  int get currentScore => starAnswers.values.fold(0, (sum, r) => sum + r);

  InspectionChecklistState copyWith({
    ChecklistEntity? checklist,
    Map<int, int>? starAnswers,
    Map<int, bool>? yesNoAnswers,
    Map<int, List<XFile>>? proofImages,
    bool? isLoadingChecklist,
    String? checklistError,
    bool? isSubmitting,
    String? submitError,
    bool? submitSuccess,
    bool clearChecklistError = false,
    bool clearSubmitError = false,
  }) {
    return InspectionChecklistState(
      checklist: checklist ?? this.checklist,
      starAnswers: starAnswers ?? this.starAnswers,
      yesNoAnswers: yesNoAnswers ?? this.yesNoAnswers,
      proofImages: proofImages ?? this.proofImages,
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
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) return;

    state = state.copyWith(isLoadingChecklist: true, clearChecklistError: true);

    final Result<ChecklistEntity, String> result = await ref
        .read(getChecklistUseCaseProvider)
        .call(partnerId: partnerId, visitId: visitId);

    state = result.when(
      success: (data) {
        // Pre-populate answers from server response
        final existingStarAnswers = <int, int>{};
        final existingYesNoAnswers = <int, bool>{};
        for (final item in data?.items ?? []) {
          if (item.existingRating != null) {
            existingStarAnswers[item.id] = item.existingRating!;
          }
          if (item.existingBoolAnswer != null) {
            existingYesNoAnswers[item.id] = item.existingBoolAnswer!;
          }
        }
        return state.copyWith(
          isLoadingChecklist: false,
          checklist: data,
          starAnswers: existingStarAnswers,
          yesNoAnswers: existingYesNoAnswers,
        );
      },
      error: (err) => state.copyWith(
        isLoadingChecklist: false,
        checklistError: err,
      ),
    );
  }

  void setStarRating({required int itemId, required int rating}) {
    final updated = Map<int, int>.from(state.starAnswers);
    if (updated[itemId] == rating) {
      updated.remove(itemId);
    } else {
      updated[itemId] = rating;
    }
    state = state.copyWith(starAnswers: updated);
  }

  void setYesNo({required int itemId, required bool value}) {
    final updated = Map<int, bool>.from(state.yesNoAnswers);
    updated[itemId] = value;
    state = state.copyWith(yesNoAnswers: updated);
  }

  Future<void> pickProofImage({required int itemId}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final updated = Map<int, List<XFile>>.from(state.proofImages);
    updated[itemId] = [...(updated[itemId] ?? []), image];
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

  Future<void> submit({required int visitId}) async {
    if (!state.isComplete) return;

    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) return;

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    final answers = <ChecklistAnswerRequestEntity>[];

    for (final item in state.checklist?.items ?? []) {
      if (item.answerType == ChecklistAnswerType.repairWork) continue;
      if (item.answerType == ChecklistAnswerType.star &&
          state.starAnswers.containsKey(item.id)) {
        answers.add(ChecklistAnswerRequestEntity(
          itemId: item.id,
          starRating: state.starAnswers[item.id],
        ));
      }
      if (item.answerType == ChecklistAnswerType.yesNo &&
          state.yesNoAnswers.containsKey(item.id)) {
        answers.add(ChecklistAnswerRequestEntity(
          itemId: item.id,
          yesNoAnswer: state.yesNoAnswers[item.id],
        ));
      }
    }

    final proofPaths = <int, List<String>>{};
    for (final entry in state.proofImages.entries) {
      proofPaths[entry.key] = entry.value.map((f) => f.path).toList();
    }

    final Result<void, String> result = await ref
        .read(submitChecklistUseCaseProvider)
        .call(
          partnerId: partnerId,
          visitId: visitId,
          request: ChecklistSubmitRequestEntity(
            answers: answers,
            proofImagePaths: proofPaths,
          ),
        );

    state = result.when(
      success: (_) => state.copyWith(isSubmitting: false, submitSuccess: true),
      error: (err) => state.copyWith(isSubmitting: false, submitError: err),
    );
  }
}
