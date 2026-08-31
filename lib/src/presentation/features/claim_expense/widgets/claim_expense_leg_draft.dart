part of '../view/claim_expense_page.dart';

/// Mutable per-row form state for one transport leg — not a domain entity;
/// [TravelExpenseLegEntity] is built from this only at submit time.
class _LegDraft {
  _LegDraft({this.mode = TransportMode.rickshaw})
    : distanceController = TextEditingController(),
      rateController = TextEditingController(
        text: mode.suggestedRatePerKm > 0
            ? mode.suggestedRatePerKm.toStringAsFixed(0)
            : '',
      );

  TransportMode mode;
  final TextEditingController distanceController;
  final TextEditingController rateController;

  double get distanceKm => double.tryParse(distanceController.text) ?? 0;
  double get ratePerKm => double.tryParse(rateController.text) ?? 0;
  double get amount => distanceKm * ratePerKm;

  // WHY replace the rate on mode change: the suggestion is per mode ("bus"
  // and "rickshaw" have different typical fares) — carrying over the old
  // mode's rate when switching would silently misprice the new one.
  void onModeChanged(TransportMode newMode) {
    mode = newMode;
    rateController.text = newMode.suggestedRatePerKm > 0
        ? newMode.suggestedRatePerKm.toStringAsFixed(0)
        : '';
  }

  TravelExpenseLegEntity toEntity() => TravelExpenseLegEntity(
    mode: mode,
    distanceKm: distanceKm,
    ratePerKm: ratePerKm,
  );

  void dispose() {
    distanceController.dispose();
    rateController.dispose();
  }
}
