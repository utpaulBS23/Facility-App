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
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return RequestDetailsPage(requestId: id);
      },
    ),
  ];
}
