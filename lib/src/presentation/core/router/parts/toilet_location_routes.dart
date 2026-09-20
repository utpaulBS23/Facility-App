part of '../router.dart';

List<GoRoute> _toiletLocationRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.toiletLocation,
      name: Routes.toiletLocation,
      builder: (context, state) => const ToiletLocationPage(),
    ),
    GoRoute(
      path: Routes.toiletDetails,
      name: Routes.toiletDetails,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return ToiletDetailsPage(facilityId: id);
      },
    ),
  ];
}
