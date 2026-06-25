import '../../core/base/base.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

final class TaskRepositoryImpl extends TaskRepository {
  static const _dummy = [
    TaskEntity(
      id: 1,
      title: 'Refill toilet tissue & soap',
      description:
          'Check and refill all tissue dispensers and soap units in the facility restrooms.',
      location: 'Mirpur-10, Dhaka',
      dueTime: '11:45 AM',
      priority: TaskPriority.medium,
      status: TaskStatus.today,
    ),
    TaskEntity(
      id: 2,
      title: 'Clean mirrors',
      description:
          'Clean all mirrors in the restroom area using appropriate cleaning agents.',
      location: 'Mirpur-10, Dhaka',
      dueTime: '11:45 AM',
      priority: TaskPriority.high,
      status: TaskStatus.today,
    ),
    TaskEntity(
      id: 3,
      title: 'Odor Control & Fragrance',
      description:
          'Replace automatic fragrance sprays and ensure the ventilation system is functioning correctly. Check for any plumbing leaks.',
      location: 'Mirpur-10, Dhaka',
      dueTime: '02:30 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
    ),
    TaskEntity(
      id: 4,
      title: 'Inspect electrical fittings',
      description:
          'Check all electrical fixtures, switches, and outlets for signs of damage or wear.',
      location: 'Mirpur-10, Dhaka',
      dueTime: '09:00 AM',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
    ),
    TaskEntity(
      id: 5,
      title: 'Floor cleaning',
      description: 'Mop and disinfect all floor surfaces in the facility.',
      location: 'Mirpur-10, Dhaka',
      dueTime: '08:00 AM',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
    ),
  ];

  @override
  Future<Result<List<TaskEntity>, Failure>> getTasks() async =>
      const Success(data: _dummy);

  @override
  Future<Result<TaskEntity, Failure>> getTaskDetail(int id) async {
    final task = _dummy.where((t) => t.id == id).firstOrNull;
    if (task == null) {
      return const Error(
        Failure(type: FailureType.notFound, message: 'Task not found'),
      );
    }
    return Success(data: task);
  }
}
