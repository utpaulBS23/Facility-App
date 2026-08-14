part of '../router.dart';

List<RouteBase> _stockRoutes(Ref ref) => [
      GoRoute(
        path: Routes.supplyRequests,
        name: Routes.supplyRequests,
        pageBuilder: (context, state) => const MaterialPage(
          child: SupplyRequestsPage(),
        ),
      ),
      GoRoute(
        path: Routes.requestDetails,
        name: Routes.requestDetails,
        pageBuilder: (context, state) {
          final request = state.extra as SupplyRequestEntity;
          return MaterialPage(
            child: RequestDetailsPage(request: request),
          );
        },
      ),
      GoRoute(
        path: Routes.deliveryComplaint,
        name: Routes.deliveryComplaint,
        pageBuilder: (context, state) {
          final item = state.extra as ReceivedItemUiModel;
          return MaterialPage(
            child: DeliveryComplaintPage(item: item),
          );
        },
      ),
      GoRoute(
        path: Routes.confirmDelivery,
        name: Routes.confirmDelivery,
        pageBuilder: (context, state) {
          final args = state.extra as ConfirmDeliveryPageArgs;
          return MaterialPage(
            child: ConfirmDeliveryPage(
              delivery: args.delivery,
              urgency: args.urgency,
              requestedByName: args.requestedByName,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.newRequest,
        name: Routes.newRequest,
        pageBuilder: (context, state) => const MaterialPage(
          child: NewRequestPage(),
        ),
      ),
      GoRoute(
        path: Routes.stock,
        name: Routes.stock,
        pageBuilder: (context, state) {
          final args = state.extra! as StockPageArgs;
          return MaterialPage(
            child: StockPage(args: args),
          );
        },
      ),
      GoRoute(
        path: Routes.updateStock,
        name: Routes.updateStock,
        pageBuilder: (context, state) {
          final args = state.extra! as UpdateStockPageArgs;
          return MaterialPage(
            child: UpdateStockPage(args: args),
          );
        },
      ),
    ];
