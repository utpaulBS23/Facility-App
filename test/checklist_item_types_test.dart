import 'package:facility_management_app/src/data/extension/checklist_mapper.dart';
import 'package:facility_management_app/src/data/models/checklist_model.dart';
import 'package:facility_management_app/src/domain/entities/checklist_entity.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _item(int id, String type, {bool required = true}) => {
  'id': id,
  'label': 'Item $id',
  'response_type': type,
  'max_points': 5,
  'proof_policy': 'no_proof',
  'is_required': required,
  'sort_order': id,
  'response': null,
};

void main() {
  final checklist = ChecklistModel.fromJson({
    'data': [_item(1, 'rating'), _item(2, 'boolean'), _item(3, 'text')],
    'meta': {'max_score': 5},
    'issues': [],
  }).toEntity();

  test('only rating and boolean items are kept', () {
    expect(checklist.items.map((i) => i.id), [1, 2]);
    expect(checklist.items.map((i) => i.answerType), [
      ChecklistAnswerType.star,
      ChecklistAnswerType.yesNo,
    ]);
  });

  test('an unsupported item does not count toward the answers', () {
    expect(checklist.totalAnswerableCount, 2);
    expect(checklist.isComplete, isFalse);
  });

  test('an unknown type or a missing type is left out too', () {
    final list = ChecklistModel.fromJson({
      'data': [
        _item(1, 'rating'),
        _item(2, 'photo_only'),
        {..._item(3, 'x')}..remove('response_type'),
      ],
      'meta': {'max_score': 5},
      'issues': [],
    }).toEntity();

    expect(list.items.map((i) => i.id), [1]);
  });
}
