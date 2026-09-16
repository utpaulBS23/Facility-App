part of '../router.dart';

List<GoRoute> _trainingRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.trainingSessions,
      name: Routes.trainingSessions,
      builder: (context, state) => const TrainingSessionsPage(),
    ),
    GoRoute(
      path: Routes.trainingSessionDetails,
      name: Routes.trainingSessionDetails,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return TrainingSessionDetailsPage(sessionId: id);
      },
    ),
  ];
}
