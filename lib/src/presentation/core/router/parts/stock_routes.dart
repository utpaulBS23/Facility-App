part of '../router.dart';

List<GoRoute> _stockRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.supplyRequests,
      name: Routes.supplyRequests,
      builder: (context, state) => const SupplyRequestsPage(),
    ),
  ];
}
