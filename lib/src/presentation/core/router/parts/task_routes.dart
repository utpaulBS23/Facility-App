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
    GoRoute(
      path: Routes.issueDetail,
      name: Routes.issueDetail,
      pageBuilder: (context, state) {
        final issue = state.extra as IssueDetailEntity;
        return MaterialPage(child: IssueDetailPage(issue: issue));
      },
    ),
  ];
}
