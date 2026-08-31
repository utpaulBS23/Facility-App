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
    GoRoute(
      path: Routes.confirmDelivery,
      name: Routes.confirmDelivery,
      builder: (context, state) {
        final (request, delivery) =
            state.extra as (SupplyRequestEntity, DeliveryEntity);
        return ConfirmDeliveryPage(
          request: request,
          delivery: delivery,
        );
      },
    ),
    GoRoute(
      path: Routes.deliveryComplaint,
      name: Routes.deliveryComplaint,
      builder: (context, state) {
        final (delivery, item) =
            state.extra as (DeliveryEntity, DeliveryItemEntity);
        return DeliveryComplaintPage(
          delivery: delivery,
          item: item,
        );
      },
    ),
    GoRoute(
      path: Routes.updateStock,
      name: Routes.updateStock,
      builder: (context, state) {
        final (facilityId, shiftAssignmentId) = state.extra as (int, int);
        return UpdateStockPage(
          facilityId: facilityId,
          shiftAssignmentId: shiftAssignmentId,
        );
      },
    ),
    GoRoute(
      path: Routes.stock,
      name: Routes.stock,
      builder: (context, state) => const StockPage(),
    ),
  ];
}
