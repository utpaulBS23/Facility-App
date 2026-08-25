part of '../router.dart';

List<GoRoute> _occurrenceRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.occurrenceChecklist,
      name: Routes.occurrenceChecklist,
      pageBuilder: (context, state) {
        final occurrence = state.extra as TaskOccurrenceEntity;
        return MaterialPage(
          child: OccurrenceChecklistPage(occurrence: occurrence),
        );
      },
    ),
  ];
}
