part of '../router.dart';

List<GoRoute> _stockRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.stock,
      name: Routes.stock,
      builder: (context, state) => const StockPage(),
    ),
    GoRoute(
      path: Routes.updateStock,
      name: Routes.updateStock,
      builder: (context, state) =>
          UpdateStockPage(args: state.extra! as UpdateStockPageArgs),
    ),
  ];
}
