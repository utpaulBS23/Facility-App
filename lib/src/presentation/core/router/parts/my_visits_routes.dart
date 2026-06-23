part of '../router.dart';

List<GoRoute> _myVisitsRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.visitDetail,
      name: Routes.visitDetail,
      pageBuilder: (context, state) {
        final visitId = state.extra as int;
        return MaterialPage(child: VisitDetailPage(visitId: visitId));
      },
    ),
    GoRoute(
      path: Routes.inspectionChecklist,
      name: Routes.inspectionChecklist,
      pageBuilder: (context, state) {
        final detail = state.extra as VisitDetailEntity;
        return MaterialPage(child: InspectionChecklistPage(detail: detail));
      },
    ),
  ];
}
