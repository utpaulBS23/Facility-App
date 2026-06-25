part of '../router.dart';

List<GoRoute> _taskRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.taskDetail,
      name: Routes.taskDetail,
      pageBuilder: (context, state) {
        final task = state.extra as TaskEntity;
        return MaterialPage(child: TaskDetailPage(task: task));
      },
    ),
  ];
}
