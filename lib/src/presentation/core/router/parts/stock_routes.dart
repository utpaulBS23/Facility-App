part of '../router.dart';

List<RouteBase> _stockRoutes(Ref ref) => [
      GoRoute(
        path: Routes.stock,
        name: Routes.stock,
        pageBuilder: (context, state) {
          final args = state.extra as StockPageArgs?;
          return MaterialPage(
            child: StockPage(args: args),
          );
        },
      ),
      GoRoute(
        path: Routes.stockAveraging,
        name: Routes.stockAveraging,
        pageBuilder: (context, state) => const MaterialPage(
          child: StockAveragingPage(),
        ),
      ),
      GoRoute(
        path: Routes.stockAveragingDetails,
        name: Routes.stockAveragingDetails,
        pageBuilder: (context, state) {
          final facilityId = state.extra is int ? state.extra as int : 31;
          return MaterialPage(
            child: StockAveragingDetailsPage(facilityId: facilityId),
          );
        },
      ),
    ];
