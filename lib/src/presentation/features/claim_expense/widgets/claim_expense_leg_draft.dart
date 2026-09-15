part of '../view/claim_expense_page.dart';

/// Mutable per-row form state for one transport leg — not a domain entity;
/// [TravelExpenseLegEntity] is built from this only at submit time.
class _LegDraft {
  _LegDraft()
    : distanceController = TextEditingController(),
      priceController = TextEditingController();

  int? vehicleTypeItemId;
  final TextEditingController distanceController;

  // WHY client-only: the backend's legs[] shape has no per-leg amount field
  // — only vehicle_type_item_id and distance_km. Per-row price is entered
  // here purely to let the user build up a total; the sum of every row's
  // price is what actually goes out, as the top-level `amount` override.
  final TextEditingController priceController;

  double get distanceKm => double.tryParse(distanceController.text) ?? 0;

  double get price => double.tryParse(priceController.text) ?? 0;

  TravelExpenseLegEntity toEntity() => TravelExpenseLegEntity(
    vehicleTypeItemId: vehicleTypeItemId!,
    distanceKm: distanceKm,
  );

  void dispose() {
    distanceController.dispose();
    priceController.dispose();
  }
}
