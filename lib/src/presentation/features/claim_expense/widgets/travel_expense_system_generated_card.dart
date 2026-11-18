import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

/// Server-computed distance/amount, shown read-only above the claim's own
/// claimed values — on the details page from the claim itself
/// (`calculated_distance_km`/`calculated_amount`/`rate_per_km`), on the
/// create page from the selected reference visit (`travel_distance_km`;
/// no amount yet, since the server only computes it once a claim exists).
class TravelExpenseSystemGeneratedCard extends StatelessWidget {
  const TravelExpenseSystemGeneratedCard({
    super.key,
    this.distanceKm,
    this.amount,
    this.calculatedCost,
    this.ratePerKm,
  });

  final double? distanceKm;
  final double? amount;

  /// `travel_calculated_cost` from the reference visit — distinct from
  /// [amount] (a submitted claim's own `calculated_amount`).
  final double? calculatedCost;
  final double? ratePerKm;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.systemGenerated,
            style: context.textStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.s8),
          if (distanceKm != null)
            _SystemGeneratedRow(
              icon: Icons.route_outlined,
              label: context.locale.calculatedDistance,
              value: context.locale.distanceKmValue(
                context.numbers.number(distanceKm!),
              ),
            ),
          if (amount != null)
            _SystemGeneratedRow(
              icon: Icons.calculate_outlined,
              label: context.locale.calculatedAmount,
              value: context.numbers.currency(amount!.round()),
            ),
          if (calculatedCost != null)
            _SystemGeneratedRow(
              icon: Icons.calculate_outlined,
              label: context.locale.calculatedCost,
              value: context.numbers.currency(calculatedCost!.round()),
            ),
          if (ratePerKm != null)
            _SystemGeneratedRow(
              icon: Icons.price_change_outlined,
              label: context.locale.ratePerKm,
              value: context.numbers.currency(ratePerKm!.round()),
            ),
        ],
      ),
    );
  }
}

class _SystemGeneratedRow extends StatelessWidget {
  const _SystemGeneratedRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s4),
      child: Row(
        children: [
          Icon(icon, size: spacing.s20, color: color.text.secondary),
          Gap(spacing.s8),
          Expanded(
            child: Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
          ),
          Text(
            value,
            style: context.textStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
