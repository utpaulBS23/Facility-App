import 'package:facility_management_app/src/domain/entities/checklist_entity.dart';
import 'package:facility_management_app/src/presentation/features/inspection_checklist/riverpod/inspection_checklist_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

ChecklistItemEntity _item({required bool hasProof}) => ChecklistItemEntity(
  id: 1,
  question: 'Clean?',
  answerType: ChecklistAnswerType.yesNo,
  order: 1,
  isRequired: true,
  proofPolicy: ChecklistProofPolicy.always,
  hasProof: hasProof,
);

InspectionChecklistState _state({
  required bool hasProof,
  bool pickedPhoto = false,
}) => InspectionChecklistState(
  checklist: ChecklistEntity(
    maxScore: 5,
    items: [_item(hasProof: hasProof)],
    issues: const [],
  ),
  yesNoAnswers: const {1: true},
  proofImages: pickedPhoto
      ? {
          1: [XFile('photo.jpg')],
        }
      : const {},
);

void main() {
  test('a photo that is only picked does not move the progress', () {
    final state = _state(hasProof: false, pickedPhoto: true);

    expect(state.totalAnswerableCount, 1);
    expect(state.answeredCount, 0);
    expect(state.isComplete, isFalse);
  });

  test('the item counts once the photo is submitted', () {
    final state = _state(hasProof: true);

    expect(state.answeredCount, 1);
    expect(state.isComplete, isTrue);
  });

  test('an answer with no photo at all does not count', () {
    expect(_state(hasProof: false).answeredCount, 0);
  });
}
