enum TaskPriority { high, medium, low }

enum TaskStatus { today, pending, completed }

class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dueTime,
    required this.priority,
    required this.status,
  });

  final int id;
  final String title;
  final String description;
  final String location;
  final String dueTime;
  final TaskPriority priority;
  final TaskStatus status;
}
