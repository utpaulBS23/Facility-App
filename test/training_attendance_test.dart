import 'package:facility_management_app/src/data/extension/training_mapper.dart';
import 'package:facility_management_app/src/data/models/training/training_response_model.dart';
import 'package:facility_management_app/src/domain/entities/training/training_completion_status.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _participant(int id, int userId, String status) => {
  'id': id,
  'user_id': userId,
  'completion_status': status,
};

void main() {
  final session = TrainingSessionResponseModel.fromJson({
    'data': {
      'id': 9,
      'title': 'Emergency Procedures',
      'facilitator_name': 'Sarah Khan',
      'scheduled_at': '2026-09-23 10:00:00',
      'duration_minutes': 60,
      'status': 'scheduled',
      'participants': [
        _participant(4, 16, 'absent'),
        _participant(3, 77, 'completed'),
      ],
    },
  }).toEntity();

  test('finds the logged-in user participant and its status', () {
    final mine = session.participantFor(16);

    expect(mine?.id, 4);
    expect(mine?.completionStatus, TrainingCompletionStatus.absent);
    expect(
      session.participantFor(77)?.completionStatus,
      TrainingCompletionStatus.completed,
    );
  });

  test('no participant for a user who is not enrolled', () {
    expect(session.participantFor(1), isNull);
    expect(session.participantFor(null), isNull);
  });

  test('session without a participants array maps to an empty list', () {
    final list = TrainingSessionResponseModel.fromJson({
      'data': {
        'id': 1,
        'title': 't',
        'facilitator_name': 'f',
        'scheduled_at': '2026-09-23 10:00:00',
        'duration_minutes': 30,
        'status': 'scheduled',
      },
    }).toEntity();

    expect(list.participants, isEmpty);
  });

  test('completion status wire values round trip', () {
    expect(
      TrainingCompletionStatus.fromWireString('completed').toWireString(),
      'completed',
    );
    expect(
      TrainingCompletionStatus.fromWireString('nonsense'),
      TrainingCompletionStatus.unknown,
    );
  });
}
