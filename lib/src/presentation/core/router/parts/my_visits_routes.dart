part of '../router.dart';

List<GoRoute> _myVisitsRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.visitDetail,
      name: Routes.visitDetail,
      pageBuilder: (context, state) {
        final visit = state.extra as VisitSummaryEntity;
        return MaterialPage(
          child: VisitDetailPage(
            visitId: visit.id,
            travelOriginType: visit.travelOriginType,
            travelOriginId: visit.travelOriginId,
          ),
        );
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
    GoRoute(
      path: Routes.problemReport,
      name: Routes.problemReport,
      pageBuilder: (context, state) {
        final extra =
            state.extra as ({int visitId, int facilityId, String facilityName});
        return MaterialPage(
          child: CreateIssuePage(
            visitId: extra.visitId,
            facilityId: extra.facilityId,
            facilityName: extra.facilityName,
          ),
        );
      },
    ),
  ];
}
