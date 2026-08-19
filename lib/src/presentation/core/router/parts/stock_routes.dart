part of '../router.dart';

List<GoRoute> _stockRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.supplyRequests,
      name: Routes.supplyRequests,
      builder: (context, state) => const SupplyRequestsPage(),
    ),
    GoRoute(
      path: Routes.requestDetails,
      name: Routes.requestDetails,
      builder: (context, state) {
        final request = state.extra as SupplyRequestEntity;
        return RequestDetailsPage(request: request);
      },
    ),
  ];
}
