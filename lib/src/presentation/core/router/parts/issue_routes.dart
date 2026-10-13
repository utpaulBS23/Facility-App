part of '../router.dart';

List<GoRoute> _issueRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.issueDetail,
      name: Routes.issueDetail,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return MaterialPage(child: IssueDetailPage(issueId: id));
      },
    ),
  ];
}
