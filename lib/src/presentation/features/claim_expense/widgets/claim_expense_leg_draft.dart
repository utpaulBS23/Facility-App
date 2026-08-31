part of '../view/claim_expense_page.dart';

/// Mutable per-row form state for one transport leg — not a domain entity;
/// [TravelExpenseLegEntity] is built from this only at submit time.
class _LegDraft {
  _LegDraft()
    : distanceController = TextEditingController(),
      rateController = TextEditingController();

  int? vehicleTypeItemId;
  final TextEditingController distanceController;
  final TextEditingController rateController;

  double get distanceKm => double.tryParse(distanceController.text) ?? 0;
  double get ratePerKm => double.tryParse(rateController.text) ?? 0;
  double get amount => distanceKm * ratePerKm;

  TravelExpenseLegEntity toEntity() => TravelExpenseLegEntity(
    vehicleTypeItemId: vehicleTypeItemId!,
    distanceKm: distanceKm,
    ratePerKm: ratePerKm,
  );

  void dispose() {
    distanceController.dispose();
    rateController.dispose();
  }
}
