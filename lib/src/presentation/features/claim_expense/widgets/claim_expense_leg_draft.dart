part of '../view/claim_expense_page.dart';

/// Mutable per-row form state for one transport leg — not a domain entity;
/// [TravelExpenseLegEntity] is built from this only at submit time.
class _LegDraft {
  _LegDraft()
    : distanceController = TextEditingController(),
      priceController = TextEditingController();

  int? vehicleTypeItemId;
  final TextEditingController distanceController;

  // WHY per-row, sent as legs[].amount: the backend now accepts a claimed
  // amount override per leg (API update 2026-11-16) — sending it per leg
  // instead of as one top-level `amount` also avoids the 422 the server
  // returns when both are sent together.
  final TextEditingController priceController;

  double get distanceKm => Digits.parseDouble(distanceController.text) ?? 0;

  double get price => Digits.parseDouble(priceController.text) ?? 0;

  TravelExpenseLegEntity toEntity() => TravelExpenseLegEntity(
    vehicleTypeItemId: vehicleTypeItemId!,
    distanceKm: distanceKm,
    amount: price,
  );

  void dispose() {
    distanceController.dispose();
    priceController.dispose();
  }
}
