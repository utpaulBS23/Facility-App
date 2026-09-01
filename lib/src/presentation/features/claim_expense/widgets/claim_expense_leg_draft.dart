part of '../view/claim_expense_page.dart';

/// Mutable per-row form state for one transport leg — not a domain entity;
/// [TravelExpenseLegEntity] is built from this only at submit time.
class _LegDraft {
  _LegDraft() : distanceController = TextEditingController();

  int? vehicleTypeItemId;
  final TextEditingController distanceController;

  double get distanceKm => double.tryParse(distanceController.text) ?? 0;

  TravelExpenseLegEntity toEntity() => TravelExpenseLegEntity(
    vehicleTypeItemId: vehicleTypeItemId!,
    distanceKm: distanceKm,
  );

  void dispose() {
    distanceController.dispose();
  }
}
