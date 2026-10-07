import 'package:facility_management_app/src/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';

TaskEntity _task(List<TaskMediaEntity> media) => TaskEntity(
  id: 1,
  title: 'Leak',
  description: '',
  location: '',
  dueTime: '',
  priority: TaskPriority.medium,
  status: TaskStatus.inProgress,
  proofRequiredOnComplete: true,
  media: media,
);

void main() {
  test('the reporter\'s creation photo is not completion proof', () {
    final task = _task(const [
      TaskMediaEntity(id: 1, url: 'a.jpg', purpose: 'creation'),
    ]);

    expect(task.media, isNotEmpty);
    expect(task.hasCompletionProof, isFalse);
  });

  test('a completion photo is completion proof', () {
    final task = _task(const [
      TaskMediaEntity(id: 1, url: 'a.jpg', purpose: 'creation'),
      TaskMediaEntity(id: 2, url: 'b.jpg', purpose: 'completion'),
    ]);

    expect(task.hasCompletionProof, isTrue);
  });

  test('no media is no proof', () {
    expect(_task(const []).hasCompletionProof, isFalse);
  });
}
