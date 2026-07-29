part of '../router.dart';

List<RouteBase> _stockRoutes(Ref ref) => [
      GoRoute(
        path: Routes.supplyRequests,
        name: Routes.supplyRequests,
        pageBuilder: (context, state) => const MaterialPage(
          child: SupplyRequestsPage(),
        ),
      ),
      // GoRoute(
      //   path: Routes.requestDetails,
      //   name: Routes.requestDetails,
      //   pageBuilder: (context, state) {
      //     final payload = state.extra as MockRequestDetailsPayload?;
      //     return MaterialPage(
      //       child: RequestDetailsPage(payload: payload),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: Routes.deliveryComplaint,
      //   name: Routes.deliveryComplaint,
      //   pageBuilder: (context, state) {
      //     final item = state.extra as MockReceivedItem?;
      //     return MaterialPage(
      //       child: DeliveryComplaintPage(item: item),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: Routes.confirmDelivery,
      //   name: Routes.confirmDelivery,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: ConfirmDeliveryPage(),
      //   ),
      // ),
      // GoRoute(
      //   path: Routes.newRequest,
      //   name: Routes.newRequest,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: NewRequestPage(),
      //   ),
      // ),
      // GoRoute(
      //   path: Routes.stock,
      //   name: Routes.stock,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: StockPage(),
      //   ),
      // ),
      // GoRoute(
      //   path: Routes.updateStock,
      //   name: Routes.updateStock,
      //   pageBuilder: (context, state) => const MaterialPage(
      //     child: UpdateStockPage(),
      //   ),
      // ),
    ];
